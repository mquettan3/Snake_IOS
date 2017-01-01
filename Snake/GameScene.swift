//
//  GameScene.swift
//  Snake
//
//  Created by Marcus Quettan on 12/17/16.
//  Copyright © 2016 Marcus Quettan. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    //High scope variables
    private var snakeLogic: SnakeLogic?
    private var snakeSegments: [SKShapeNode] = []
    private var timer : Timer!
    private var flareTimer : Timer!
    private var runCount : Int = 0
    private var scoreLabel: SKLabelNode!
    private var scoreLabelShadow: SKLabelNode!
    private var isGamePaused: Bool = false
    private var flare = SKSpriteNode(imageNamed: "1")
    private var score : Int = 0 {
        didSet {
            self.scoreLabel.text = "Score: \(score)"
            self.scoreLabelShadow.text = "Score: \(score)"
        }
    }
    
    //Audio Players
    var musicPlayer : AVAudioPlayer?
    var foodSoundPlayer : AVAudioPlayer?
    var deathSoundPlayer : AVAudioPlayer?
    var flareSoundPlayer : AVAudioPlayer?
    
    //Configuration Parameters
    private var snakeScale = 30
    private var snakeInitialLength = 10
    private var foodTypeArray : [String] = ["banana", "black-berry-light", "black-cherry", "coconut", "green-apple", "green-grape", "lemon", "lime", "orange", "peach", "pear", "plum", "raspberry", "red-apple", "red-cherry", "red-grape", "star-fruit", "strawberry", "watermelon"]
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
        self.food.size.width = snakeLogic!.snakeSize.width * 1.5
        self.food.size.height = snakeLogic!.snakeSize.height * 1.5
        self.food.zPosition = -1
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
        scoreLabelShadow = self.childNode(withName: "CurrentScoreLabelShadow") as! SKLabelNode
        
        //Start Game Loop Timer
        //self.timer = timer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(timeInterval: currentDifficulty.rawValue, target: self, selector: #selector(self.timerMethod), userInfo: nil, repeats: true)
        
        //Create Spinny Flare Node
        flare.size.height = snakeLogic!.snakeSize.height * 2
        flare.size.width = snakeLogic!.snakeSize.width * 2
        flare.position = CGPoint(x: 0, y: 0)
        let flareAction = SKAction(named: "SpinFlare")
        flare.run(flareAction!)
        flare.isHidden = true
        self.addChild(flare)
        
        //Begin Flare Spawn Timer
        self.flareTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.flareTimerMethod), userInfo: nil, repeats: true)
        
        //Play Music
        playMusic()
    }
    
    @objc private func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                snakeLogic!.changeDirection(.Up)
            case UISwipeGestureRecognizerDirection.down:
                snakeLogic!.changeDirection(.Down)
            case UISwipeGestureRecognizerDirection.left:
                snakeLogic!.changeDirection(.Left)
            case UISwipeGestureRecognizerDirection.right:
                snakeLogic!.changeDirection(.Right)
            default:
                break
            }
        }
    }
    
    @objc private func timerMethod() {
        if(!isGamePaused) {
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
                score = snakeLogic!.updateScore(FoodTypes.Fruit)
                
                //Play Food Sound
                playFoodSound()
            }
            
            //Handle the case where we're eating a flare for this update
            if(snakeLogic!.points[0] == flare.position && !flare.isHidden) {
                score = snakeLogic!.updateScore(FoodTypes.Flare)
                flare.isHidden = true
                
                //Play Flare Sound
                playFlareSound()
            }
            
            //Update the snake drawing for each point in snake
            var i: Int = 0
            for segment in snakeSegments {
                segment.position = snakeLogic!.points[i]
                segment.zPosition = 0
                segment.fillColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.9)
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
                
                //Stop Music
                musicPlayer!.stop()
                
                //Play Death Sound
                playDeathSound()
                
                //Ivalidate the timer
                timer.invalidate()
            }
        }
    }
    
    @objc private func flareTimerMethod() {
        if(!isGamePaused) {
            //Show the flare1
            snakeLogic!.generateFlare()
            flare.position = snakeLogic!.flareLocation
            flare.run(SKAction(named: "Unhide")!)
            
            //Hide flare X seconds later
            flare.run(SKAction(named: "HideFlare")!)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Everything is done in the timerMethod
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            for node in nodeArray {
                let pauseMenu = self.childNode(withName: "GamePausedLabel") as! SKLabelNode
                let pauseMenuShadow = self.childNode(withName: "GamePausedLabelShadow") as! SKLabelNode
                let unhideAction = SKAction(named: "Unhide")
                let hideAction = SKAction(named: "Hide")
                //If Start Button is Pressed
                if (node.name == "PauseButton") {
                    if(isGamePaused) {
                        //Resume the game
                        isGamePaused = false
                        
                        //Resume the music
                        musicPlayer!.play()
                        
                        //Hide Pause Menu
                        pauseMenu.run(hideAction!)
                        pauseMenuShadow.run(hideAction!)
                    } else {
                        //Pause the game
                        isGamePaused = true
                        
                        //Pause the Music
                        musicPlayer!.pause()
                        
                        //Show the pause menu
                        pauseMenu.run(unhideAction!)
                        pauseMenuShadow.run(unhideAction!)
                    }
                } else if (node.name == "YesButton") {
                    //Pause the Game
                    isGamePaused = true
                    
                    //Stop Music
                    musicPlayer!.stop()
                    
                    //Present the Main Menu Scene
                    let mainMenuTransition = SKTransition.fade(withDuration: 2)
                    let mainMenuScene = SKScene(fileNamed: "MainMenuScene")!
                    mainMenuScene.scaleMode = .fill
                    self.view?.presentScene(mainMenuScene, transition: mainMenuTransition);
                } else if (node.name == "NoButton") {
                    //Resume the game
                    isGamePaused = false
                    
                    //Resume the music
                    musicPlayer!.play()
                    
                    //Hide the pause menu
                    pauseMenu.run(hideAction!)
                    pauseMenuShadow.run(hideAction!)
                }
            }
        }
    }
    
    private func playMusic() {
        guard let sound = NSDataAsset(name: "me-and-my-guitar") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            musicPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            musicPlayer!.numberOfLoops = -1
            musicPlayer!.volume = 0.5
            musicPlayer!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    private func playFoodSound() {
        guard let sound = NSDataAsset(name: "food-sound") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            foodSoundPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            foodSoundPlayer!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    private func playFlareSound() {
        guard let sound = NSDataAsset(name: "flare-sound") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            flareSoundPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            flareSoundPlayer!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    private func playDeathSound() {
        guard let sound = NSDataAsset(name: "death-sound") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            deathSoundPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            deathSoundPlayer!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    
}
