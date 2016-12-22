//
//  Snake.swift
//  Snake
//
//  Created by Marcus Quettan on 12/19/16.
//  Copyright © 2016 Marcus Quettan. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction {
    case Left
    case Right
    case Down
    case Up
}

class Snake {
    var points = [CGPoint]()
    var width: CGFloat = 30
    
    init() {
        
    }
    
    init(screenWidth: Int, screenHeight: Int, gridWidth: Int, gridHeight: Int){
        
    }
    
    func move(direction: Direction) {
        switch direction {
        case .Left:
            //New Head position is one width left of the current position.
            points.insert(CGPoint(x: (self.points[0].x - self.width), y: points[0].y), at: 0)
            points.removeLast()
        case .Right:
            //New Head position is one width right of the current position.
            points.insert(CGPoint(x: (points[0].x + self.width), y: points[0].y), at: 0)
            points.removeLast()
        case .Up:
            //New Head position is one width above of the current position.
            points.insert(CGPoint(x: points[0].x, y: (points[0].y - self.width)), at: 0)
            points.removeLast()
        case .Down:
            //New Head position is one width below of the current position.
            points.insert(CGPoint(x: points[0].x, y: (points[0].y + self.width)), at: 0)
            points.removeLast()
        }
    }
    
    
}
