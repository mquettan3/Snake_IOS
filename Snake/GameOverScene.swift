//
//  GameOverScene.swift
//  Snake
//
//  Created by Marcus Quettan on 12/27/16.
//  Copyright © 2016 Marcus Quettan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameOverTransition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(SKScene(fileNamed: "GameScene")!, transition: gameOverTransition);
    }
}
