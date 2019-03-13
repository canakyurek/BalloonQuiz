//
//  Scene.swift
//  Balloon
//
//  Created by Can Akyurek on 18.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameSceneDelegate: class {
    func balloonDidCrash()
}

class Scene: SKScene {

    var sceneCamera: SKCameraNode!
    var floor: SKSpriteNode!
    let balloon = BalloonNode()
    let notificationCenter = NotificationCenter.default
    weak var sceneDelegate: GameSceneDelegate?
    
    init(delegate: GameSceneDelegate?) {
        super.init()
        
        sceneDelegate = delegate
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setCamera() {
        sceneCamera = SKCameraNode()
        sceneCamera.position = CGPoint(x: 0, y: 0)
        self.camera = sceneCamera
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = .clear
        self.scaleMode = .aspectFill
        notificationCenter.addObserver(self,
                                       selector: #selector(self.applyImpulse),
                                       name: NSNotification.Name("CorrectAnswer"),
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.knockOffTheBalloon),
                                       name: NSNotification.Name("FalseAnswer"),
                                       object: nil)
        setCamera()
        balloon.spawn(on: self,
                      position: CGPoint(x: 40, y: 500),
                      size: CGSize(width: 70, height: 100))
        setupFloor()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        sceneCamera.position = CGPoint(x: balloon.position.x + 150,
                                       y: balloon.position.y - 100)
    }
    
    @objc func applyImpulse() {
        balloon.refuel()
    }
    
    @objc func knockOffTheBalloon() {
        balloon.moveToFloor()
    }
    
    func setupFloor() {
        floor = SKSpriteNode(color: .red, size: CGSize(width: self.frame.width, height: 10))
        floor.position = CGPoint(x: 0, y: -50)
        floor.anchorPoint = CGPoint.zero
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.categoryBitMask = Category.floor.rawValue
        floor.physicsBody?.contactTestBitMask = Category.balloon.rawValue
        floor.physicsBody?.collisionBitMask = Category.balloon.rawValue
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.affectedByGravity = false
        
        self.addChild(floor)
    }
}

extension Scene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == Category.balloon.rawValue
            || contact.bodyB.categoryBitMask == Category.balloon.rawValue {
            if contact.bodyA.categoryBitMask == Category.floor.rawValue
                || contact.bodyB.categoryBitMask == Category.floor.rawValue {
                sceneDelegate?.balloonDidCrash()
            }
        }
    }
}
