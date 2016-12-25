//
//  GameScene.swift
//  Snake
//
//  Created by Marcus Quettan on 12/17/16.
//  Copyright © 2016 Marcus Quettan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var snakeLogic: SnakeLogic?
    private var snakeSegments: [SKShapeNode] = [SKShapeNode()]
    private var snakeSize: CGSize!
    private var food = SKSpriteNode(imageNamed: "apple")
    private var timer : Timer!
    private var snakeScale = 30
    
    override func didMove(to view: SKView) {
        //Init Snake Logic Class
        snakeLogic = SnakeLogic(worldSize: self.frame.size, snakeSize: CGSize(width: snakeScale, height: snakeScale))
        
        //Create the Snake's Head
        snakeSize = CGSize(width: snakeLogic!.snakeSize.width, height: snakeLogic!.snakeSize.height)
        snakeSegments[0] = SKShapeNode(rectOf: snakeSize)
        self.addChild(snakeSegments[0])
        
        //Create initial food
        self.food.position = snakeLogic!.foodLocation
        self.food.size = snakeSize
        self.addChild(food)
        
        //Start the four gesture recognizers for each swipe direction
        //Up
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view!.addGestureRecognizer(swipeUp)
        //Down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view!.addGestureRecognizer(swipeDown)
        //Left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view!.addGestureRecognizer(swipeLeft)
        //Right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view!.addGestureRecognizer(swipeRight)
        
        //Start Game Loop Timer
        //self.timer = timer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(timeInterval: Difficulty.Easy.rawValue, target: self, selector: #selector(self.timerMethod), userInfo: nil, repeats: true)
    }
    
    @objc private func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                snakeLogic!.currentDirection = .Right
            case UISwipeGestureRecognizerDirection.down:
                snakeLogic!.currentDirection = .Down
            case UISwipeGestureRecognizerDirection.left:
                snakeLogic!.currentDirection = .Left
            case UISwipeGestureRecognizerDirection.up:
                snakeLogic!.currentDirection = .Up
            default:
                break
            }
        }
    }
    
    @objc private func timerMethod() {
        //Move Every Update
        snakeLogic!.move()
        
        //Handle the case where we're eating food for this update
        if(snakeLogic!.didEatFood) {
            snakeLogic!.generateFood()
            food.position = snakeLogic!.foodLocation
            //food.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            print("Created food at \(food.position)")
            snakeSegments.append(SKShapeNode(rectOf: snakeSize))
            snakeLogic!.didEatFood = false
        }
        
        //Update the snake drawing for each point in snake
        var i: Int = 0
        for segment in snakeSegments {
            segment.position = snakeLogic!.points[i]
            i += 1
            segment.removeFromParent()
            self.addChild(segment)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Everything is done in the timerMethod
        
    }
}
