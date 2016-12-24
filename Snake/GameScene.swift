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
    private var snakeLogic = SnakeLogic()
    private var snakeSegments: [SKShapeNode] = [SKShapeNode()]
    private var snakeSize: CGSize!
    
    override func didMove(to view: SKView) {
        //Create the Snake's Head
        snakeSize = CGSize(width: self.frame.width/30, height: self.frame.width/30)
        snakeSegments[0] = SKShapeNode(rectOf: snakeSize)
        self.addChild(snakeSegments[0])
        
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
        
    }
    
    @objc private func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                snakeLogic.currentDirection = .Right
            case UISwipeGestureRecognizerDirection.down:
                snakeLogic.currentDirection = .Down
            case UISwipeGestureRecognizerDirection.left:
                snakeLogic.currentDirection = .Left
            case UISwipeGestureRecognizerDirection.up:
                snakeLogic.currentDirection = .Up
            default:
                break
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Move Every Update
        //Fix this to be variable on game difficulty setting
        //snakeLogic.eat()
        //snakeSegments.append(SKShapeNode(rectOf: snakeSize))
        snakeLogic.move()
        if((abs(snakeLogic.points[0].x) * 2) > self.frame.width) {
            snakeLogic.points[0].x *= -1
        }
        if((abs(snakeLogic.points[0].y) * 2) > self.frame.height) {
            snakeLogic.points[0].y *= -1
        }
        
        
        //Update the snake drawing for each point in snake
        var i: Int = 0
        for segment in snakeSegments {
            segment.position = snakeLogic.points[i]
            i += 1
            segment.removeFromParent()
            self.addChild(segment)
        }
        
    }
}
