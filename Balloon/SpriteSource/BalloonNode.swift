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
        let moveDownward = SKAction.move(by: CGVector(dx: 0, dy: -40), duration: 2)
        let actionGroup = SKAction.group([rotationSequence, moveDownward])
        let action = SKAction.repeatForever(actionGroup)
        run(action)
    }
    
    func refuel() {
        let moveUpward = SKAction.move(by: CGVector(dx: 0, dy: 120),
                                       duration: 2)
        let zeroRotation = SKAction.rotate(toAngle: 0, duration: 2)
        let group = SKAction.group([moveUpward, zeroRotation])
        run(group)
    }
    
    func crash() {
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
    }
}
