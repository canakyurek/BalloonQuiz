//
//  BalloonNode.swift
//  Balloon
//
//  Created by Can Akyurek on 18.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import SpriteKit

class BalloonNode: SKSpriteNode {

    func spawn(on parentNode: SKNode,
               position: CGPoint,
               size: CGSize) {
        
        self.texture = SKTexture(imageNamed: "balloon")
        parentNode.addChild(self)
        self.position = position
        self.size = size
        setupPhysicsBody()
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.color = .yellow
        // Pi / 36 is 5 degrees
        let rotateRight = SKAction.rotate(byAngle: .pi / 36, duration: 0.5)
        let rotateLeft = SKAction.rotate(byAngle: -(.pi / 18), duration: 0.5)
        let rotateLeft2 = SKAction.rotate(byAngle: (.pi / 18), duration: 0.5)
        let rotateRight2 = SKAction.rotate(byAngle: -(.pi / 36), duration: 0.5)
        let rotationSequence = SKAction.sequence([
            rotateRight,
            rotateLeft,
            rotateRight2,
            rotateLeft2])
        let moveDownward = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 2)
        let actionGroup = SKAction.group([rotationSequence, moveDownward])
        let action = SKAction.repeatForever(actionGroup)
        run(action)
    }
    
    private func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Category.balloon.rawValue
        self.physicsBody?.contactTestBitMask = Category.floor.rawValue
        self.physicsBody?.collisionBitMask = Category.floor.rawValue
    }
    
    func refuel() {
        let moveUpward = SKAction.move(by: CGVector(dx: 0, dy: 200),
                                       duration: 2)
        let zeroRotation = SKAction.rotate(toAngle: 0, duration: 2)
        let group = SKAction.group([moveUpward, zeroRotation])
        run(group)
    }
    
    func moveToFloor() {
        let point = CGPoint(x: self.position.x, y: 100)
        self.physicsBody = nil
        let moveToFloor = SKAction.move(to: point, duration: 1)
        // Set the speed zero when the balloon hits the floor
        // in order to prevent further motion.
        run(moveToFloor) { [weak self] in
            guard let `self` = self else { return }
            self.speed = 0
        }
    }
    
    func crash() {
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
    }
}

enum Category: UInt32 {
    case balloon = 0b001
    case floor = 0b010
}
