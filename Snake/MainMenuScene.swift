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
        print("Touch Happened")
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
                
                //If Leaderboards Button is Pressed
                if (node.name == "LeaderboardButton") {
                    let startGameTransition = SKTransition.fade(withDuration: 0.5)
                    let gameScene = SKScene(fileNamed: "GameScene")!
                    gameScene.scaleMode = .fill
                    self.view?.presentScene(gameScene, transition: startGameTransition);
                }
                
            }
        }
    }
}
