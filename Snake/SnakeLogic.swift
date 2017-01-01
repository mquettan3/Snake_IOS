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
    case Easy = 0.25
    case Medium = 0.125
    case Hard = 0.0625
}

enum FoodTypes {
    case Flare
    case Fruit
}

class SnakeLogic {
    //Public Variables
    var points: [CGPoint]
    var snakeSize: CGSize
    var didEatFood: Bool
    var foodLocation: CGPoint
    var flareLocation: CGPoint
    var currentScore: Int
    
    //Private Variables
    private var previousMovedDirection: Direction?
    private var worldSize: CGSize
    private var currentDirection: Direction
    
    init(worldSize: CGSize, snakeSize: CGSize, initialLength: Int) {
        self.worldSize = worldSize
        self.snakeSize = snakeSize
        self.foodLocation = CGPoint(x: 0, y: 0)
        self.flareLocation = CGPoint(x: 0, y: 0)
        self.didEatFood = false
        self.points = []
        self.currentDirection = .Up
        self.currentScore = 0
        
        
        for index in 0..<initialLength {
            self.points.append(CGPoint(x: snakeSize.width * CGFloat(index), y: 0))
        }
    }
    
    func changeDirection(_ direction: Direction) {
        if let previousMovedDirection = self.previousMovedDirection {
            switch(direction) {
            case .Left:
                if(previousMovedDirection != .Right) {
                    self.currentDirection = direction
                }
            case .Right:
                if(previousMovedDirection != .Left) {
                    self.currentDirection = direction
                }
            case .Down:
                if(previousMovedDirection != .Up) {
                    self.currentDirection = direction
                }
            case .Up:
                if(previousMovedDirection != .Down) {
                    self.currentDirection = direction
                }
            }
        }
    }
    
    func move() {
        previousMovedDirection = currentDirection
        switch currentDirection {
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
    
    private func wrapEdges() {
        let cols = UInt32(floor(self.worldSize.width / self.snakeSize.width))
        let rows = UInt32(floor(self.worldSize.height / self.snakeSize.height))
        let maxWidth = CGFloat(cols) * self.snakeSize.width
        let maxHeight = CGFloat(rows) * self.snakeSize.height
        
        //If we've hit the edge of the world, loop to the other side!
        if(((abs(self.points[0].x) + (self.snakeSize.width / 2)) * 2) > maxWidth) {
            if(self.points[0].x < 0) {
                self.points[0].x += self.snakeSize.width
            } else {
                self.points[0].x -= self.snakeSize.width
            }
            self.points[0].x *= -1
            
        }
        if(((abs(self.points[0].y) + (snakeSize.height / 2)) * 2) > maxHeight) {
            if(self.points[0].y < 0) {
                self.points[0].y += self.snakeSize.height
            } else {
                self.points[0].y -= self.snakeSize.height
            }
            self.points[0].y *= -1
        }
    }
    
    func generateFood() {
        let cols = UInt32(floor(self.worldSize.width / self.snakeSize.width))
        let rows = UInt32(floor(self.worldSize.height / self.snakeSize.height))
        
        self.foodLocation.x = CGFloat(UInt32(self.snakeSize.width) * arc4random_uniform(cols)) - (CGFloat(cols / 2) * self.snakeSize.width)
        self.foodLocation.y = CGFloat(UInt32(self.snakeSize.height) * arc4random_uniform(rows - 1)) - (CGFloat(rows / 2) * self.snakeSize.height - self.snakeSize.height)
        
        for point in points {
            if(point == self.foodLocation) {
                self.generateFood()
            }
        }
    }
    
    func generateFlare() {
        let cols = UInt32(floor(self.worldSize.width / self.snakeSize.width))
        let rows = UInt32(floor(self.worldSize.height / self.snakeSize.height))
        
        self.flareLocation.x = CGFloat(UInt32(self.snakeSize.width) * arc4random_uniform(cols)) - (CGFloat(cols / 2) * self.snakeSize.width)
        self.flareLocation.y = CGFloat(UInt32(self.snakeSize.height) * arc4random_uniform(rows - 1)) - (CGFloat(rows / 2) * self.snakeSize.height - self.snakeSize.height)
        
        for point in points {
            if(point == self.flareLocation) {
                self.generateFlare()
            }
        }
    }
    
    func didGameEnd() -> Bool {
        //If the head touches any of the body
        var count = 0
        for body in points {
            if ((body == points[0]) && (count != 0)) {
                return true
            }
            count += 1
        }
        return false
    }
    
    func updateScore(_ foodType: FoodTypes) -> Int {
        switch(foodType) {
        case .Fruit:
            self.currentScore += 30
        case .Flare:
            self.currentScore += 100
        }
        return self.currentScore
    }
    
}
