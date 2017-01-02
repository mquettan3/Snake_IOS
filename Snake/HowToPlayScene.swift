//
//  HowToPlayScene.swift
//  Snake
//
//  Created by Marcus Quettan on 1/2/17.
//  Copyright © 2017 Marcus Quettan. All rights reserved.
//

import SpriteKit

class HowToPlayScene : SKScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Present the Main Menu
        let mainMenuTransition = SKTransition.fade(withDuration: 0.5)
        let mainMenuScene = SKScene(fileNamed: "MainMenuScene")!
        mainMenuScene.scaleMode = .fill
        self.view?.presentScene(mainMenuScene, transition: mainMenuTransition);
    }
}
