//
//  MainMenuScene.swift
//  Snake
//
//  Created by Marcus Quettan on 12/27/16.
//  Copyright © 2016 Marcus Quettan. All rights reserved.
//
import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            for node in nodeArray {
                //If Start Button is Pressed
                if (node.name == "StartButton") {
                    let startGameTransition = SKTransition.fade(withDuration: 0.5)
                    let gameScene = SKScene(fileNamed: "GameScene")!
                    gameScene.scaleMode = .fill
                    self.view?.presentScene(gameScene, transition: startGameTransition);
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
    }
}
