//
//  GameScene.swift
//  Snake
//
//  Created by Marcus Quettan on 12/17/16.
//  Copyright © 2016 Marcus Quettan. All rights reserved.
//

import SpriteKit
import GameplayKit

var currentDifficulty = Difficulty.Easy

class GameScene: SKScene {
    
    //High scope variables
    private var snakeLogic: SnakeLogic?
    private var snakeSegments: [SKShapeNode] = []
    private var timer : Timer!
    private var runCount : Int = 0
    private var scoreLabel: SKLabelNode!
    private var score : Int = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(score)"
        }
    }
    
    //Configuration Parameters
    private var snakeScale = 30
    private var snakeInitialLength = 10
    private var foodTypeArray : [String] = ["banana", "black-berry-dark", "black-berry-dark", "black-berry-light", "black-cherry", "coconut", "green-apple", "green-grape", "lemon", "lime", "orange", "peach", "pear", "plum", "raspberry", "red-apple", "red-cherry", "red-grape", "star-fruit", "strawberry", "watermelon"]
    private var food = SKSpriteNode(imageNamed: "red-apple")
    
    override func didMove(to view: SKView) {
        //Init Snake Logic Class
        snakeLogic = SnakeLogic(worldSize: self.frame.size, snakeSize: CGSize(width: snakeScale, height: snakeScale), initialLength: snakeInitialLength)
        
        //Create the Snake's Head
        for index in 0..<snakeLogic!.points.count {
            snakeSegments.append(SKShapeNode(rectOf: snakeLogic!.snakeSize))
            self.addChild(snakeSegments[index])
        }
        
        //Create initial food
        snakeLogic!.generateFood()
        self.food.position = snakeLogic!.foodLocation
        self.food.size = snakeLogic!.snakeSize
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
        
        //Populate Score Label
        scoreLabel = self.childNode(withName: "CurrentScoreLabel") as! SKLabelNode
        
        //Start Game Loop Timer
        //self.timer = timer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(timeInterval: currentDifficulty.rawValue, target: self, selector: #selector(self.timerMethod), userInfo: nil, repeats: true)
    }
    
    @objc private func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if(snakeLogic!.currentDirection != .Left) {
                    snakeLogic!.currentDirection = .Right
                }
            case UISwipeGestureRecognizerDirection.down:
                if(snakeLogic!.currentDirection != .Up) {
                    snakeLogic!.currentDirection = .Down
                }
            case UISwipeGestureRecognizerDirection.left:
                if(snakeLogic!.currentDirection != .Right) {
                    snakeLogic!.currentDirection = .Left
                }
            case UISwipeGestureRecognizerDirection.up:
                if(snakeLogic!.currentDirection != .Down) {
                    snakeLogic!.currentDirection = .Up
                }
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
            //Create a random image for the food
            self.food.texture = SKTexture(imageNamed: foodTypeArray[Int(arc4random_uniform(UInt32(foodTypeArray.count)))])
            
            //Random location for the food
            snakeLogic!.generateFood()
            food.position = snakeLogic!.foodLocation
            
            //Increase the size of the visual snake
            snakeSegments.append(SKShapeNode(rectOf: snakeLogic!.snakeSize))
            snakeLogic!.didEatFood = false
            score = snakeLogic!.updateScore()
        }
        
        //Update the snake drawing for each point in snake
        var i: Int = 0
        for segment in snakeSegments {
            segment.position = snakeLogic!.points[i]
            i += 1
            segment.removeFromParent()
            self.addChild(segment)
        }
        
        if(snakeLogic!.didGameEnd()) {
            //Save High Score
            let userDefaults = UserDefaults.standard
            if(snakeLogic!.currentScore > userDefaults.integer(forKey: "HighScore")) {
                userDefaults.set(snakeLogic!.currentScore, forKey: "HighScore")
            }
            
            //Present the Game Over Scene
            let gameOverTransition = SKTransition.fade(withDuration: 2)
            let gameOverScene = SKScene(fileNamed: "GameOverScene")!
            gameOverScene.scaleMode = .fill
            self.view?.presentScene(gameOverScene, transition: gameOverTransition);
            
            //Ivalidate the timer
            timer.invalidate()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Everything is done in the timerMethod
        
    }
}
