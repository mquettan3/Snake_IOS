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

class SnakeLogic {
    var points: [CGPoint] = [CGPoint(x: 0, y: 0)]
    var width: CGFloat = 30
    var currentDirection : Direction = .Up
    private var didEatFood = false
    var foodLocation = CGPoint(x: 0, y: 0)
    
    func move(_ direction: Direction) {
        switch direction {
        case .Left:
            //New Head position is one width left of the current position.
            self.points.insert(CGPoint(x: (self.points[0].x - self.width), y: self.points[0].y), at: 0)
        case .Right:
            //New Head position is one width right of the current position.
            self.points.insert(CGPoint(x: (self.points[0].x + self.width), y: self.points[0].y), at: 0)
        case .Up:
            //New Head position is one width above of the current position.
            self.points.insert(CGPoint(x: self.points[0].x, y: (self.points[0].y + self.width)), at: 0)
        case .Down:
            //New Head position is one width below of the current position.
            self.points.insert(CGPoint(x: self.points[0].x, y: (self.points[0].y - self.width)), at: 0)
        }
        
        if(didEatFood) {
            //If we've eaten, when we move don't remove the last point this time.
            self.didEatFood = false
        } else {
            //If we haven't eaten, remove the last point so the snake moves
            self.points.removeLast()
        }
    }
    
    func move() {
        self.move(currentDirection)
    }
    
    func generateFood() {
        
    }
    
    func eat() {
        self.didEatFood = true;
    }
    
    
}
