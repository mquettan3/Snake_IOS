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

enum Difficulty: Double {
    case Easy = 0.75
    case Medium = 0.5
    case Hard = 0.25
}

class SnakeLogic {
    var points: [CGPoint]
    var snakeSize: CGSize
    var currentDirection: Direction
    var didEatFood: Bool
    var foodLocation: CGPoint
    private var worldSize: CGSize
    
    init(worldSize: CGSize, snakeSize: CGSize) {
        self.worldSize = worldSize
        self.snakeSize = snakeSize
        self.foodLocation = CGPoint(x: 0, y: 0)
        self.didEatFood = false
        self.points = [CGPoint(x: 0, y: 0)]
        self.currentDirection = .Up
    }
    
    func move(_ direction: Direction) {
        switch direction {
        case .Left:
            //New Head position is one width left of the current position.
            self.points.insert(CGPoint(x: (self.points[0].x - self.snakeSize.width), y: self.points[0].y), at: 0)
        case .Right:
            //New Head position is one width right of the current position.
            self.points.insert(CGPoint(x: (self.points[0].x + self.snakeSize.width), y: self.points[0].y), at: 0)
        case .Up:
            //New Head position is one width above of the current position.
            self.points.insert(CGPoint(x: self.points[0].x, y: (self.points[0].y + self.snakeSize.height)), at: 0)
        case .Down:
            //New Head position is one width below of the current position.
            self.points.insert(CGPoint(x: self.points[0].x, y: (self.points[0].y - self.snakeSize.height)), at: 0)
        }
        
        self.wrapEdges()
        
        if(self.points[0] == self.foodLocation){
            self.didEatFood = true
        }
        
        if(!self.didEatFood) {
            //If we haven't eaten, remove the last point so the snake moves
            self.points.removeLast()
        }
    }
    
    func move() {
        self.move(currentDirection)
    }
    
    func wrapEdges() {
        //If we've hit the edge of the world, loop to the other side!
        if(((abs(self.points[0].x) + (self.snakeSize.width / 2)) * 2) > self.worldSize.width) {
            if(self.points[0].x < 0) {
                self.points[0].x += self.snakeSize.width
            } else {
                self.points[0].x -= self.snakeSize.width
            }
            self.points[0].x *= -1
            
        }
        if(((abs(self.points[0].y) + (snakeSize.height / 2)) * 2) > self.worldSize.height) {
            if(self.points[0].y < 0) {
                self.points[0].y += self.snakeSize.height
            } else {
                self.points[0].y -= self.snakeSize.height
            }
            self.points[0].y *= -1
        }
    }
    
    func generateFood() {
        self.foodLocation.x = CGFloat(UInt32(self.snakeSize.width) * arc4random_uniform(6))
        self.foodLocation.y = CGFloat(UInt32(self.snakeSize.height) * arc4random_uniform(6))
    }
    
}
