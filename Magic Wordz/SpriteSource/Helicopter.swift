//
//  Helicopter.swift
//  Magic Wordz
//
//  Created by Can Akyurek on 15.07.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import SpriteKit

class Helicopter: SKSpriteNode {

    func spawn(on parentNode: SKNode,
               position: CGPoint,
               size: CGSize) {
        self.texture = SKTexture(imageNamed: "helicopter")
        self.position = position
        self.size = size
        parentNode.addChild(self)
        setupPhysicsBody()
    }
    
    private func setupMovement() {
        
    }
    
    private func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        var xVelocity = 100
//        if helicopter.position.x > 300 || helicopter.position.x < 50 {
//            xVelocity *= -1
//            helicopter.zRotation = .pi
//        }
//        helicopter.physicsBody?.velocity = CGVector(dx: xVelocity, dy: 0)
    }
}
