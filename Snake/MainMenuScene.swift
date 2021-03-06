//
//  MainMenuScene.swift
//  Snake
//
//  Created by Marcus Quettan on 12/27/16.
//  Copyright © 2016 Marcus Quettan. All rights reserved.
//
import SpriteKit
import GameplayKit

var currentDifficulty = Difficulty.Easy
var gameScene: SKScene?

class MainMenuScene: SKScene {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            for node in nodeArray {
                //If Start Button is Pressed
                if (node.name == "StartButton") {
                    let startGameTransition = SKTransition.fade(withDuration: 0.5)
                    gameScene = SKScene(fileNamed: "GameScene")!
                    gameScene!.scaleMode = .fill
                    self.view?.presentScene(gameScene!, transition: startGameTransition);
                }
                
                //If Difficulty Button is Pressed
                if (node.name == "DifficultyButton") {
                    self.setDifficulty()
                }
                
                //If How to play node is Pressed
                if (node.name == "HowToPlayLabel") {
                    //Present the How to Play Scene
                    let howToPlayTransition = SKTransition.fade(withDuration: 0.5)
                    let howToPlayScene = SKScene(fileNamed: "HowToPlayScene")!
                    howToPlayScene.scaleMode = .fill
                    self.view?.presentScene(howToPlayScene, transition: howToPlayTransition);
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        //Populate High Score Label
        let highScoreLabel = self.childNode(withName: "HighScoreLabel") as! SKLabelNode
        let userDefaults = UserDefaults.standard
        let currentHighScore = userDefaults.integer(forKey: "HighScore")
        highScoreLabel.text = "High Score: \(currentHighScore)"
        
        //Set the difficulty
        self.setDifficulty()
    }
    
    func setDifficulty() {
        let difficultyLabel = self.childNode(withName: "DifficultyLabel") as! SKLabelNode
        switch(difficultyLabel.text!) {
        case "Difficulty: Easy":
            //Set difficulty to Medium
            difficultyLabel.text = "Difficulty: Medium"
            currentDifficulty = Difficulty.Medium
        case "Difficulty: Medium":
            //Set difficulty to Hard
            difficultyLabel.text = "Difficulty: Hard"
            currentDifficulty = Difficulty.Hard
        case "Difficulty: Hard":
            //Set difficulty to Easy
            difficultyLabel.text = "Difficulty: Easy"
            currentDifficulty = Difficulty.Easy
        default:
            print("Undefined Difficulty - This should never happen")
        }
    }
}
