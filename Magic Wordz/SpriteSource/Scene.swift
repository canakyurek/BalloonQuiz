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
    lazy var helicopter = Helicopter()
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
    
    func setBackground() {
        let topColor = CIColor(cgColor: UIColor(named: "sky2")!.cgColor)
        let bottomColor = CIColor(cgColor: UIColor(named: "sky1")!.cgColor)
        
        let texture = SKTexture(size: CGSize(width: self.frame.width, height: 5000), color1: bottomColor, color2: topColor)
        texture.filteringMode = .nearest
        let sprite = SKSpriteNode(texture: texture)
        sprite.position = CGPoint(x: self.frame.midX, y: 2500)
        sprite.size.width = self.frame.width
        sprite.size.height = CGFloat(5000)
        sprite.zPosition = -1
        addChild(sprite)
    }
    
    func addBackground() {
        let topColor = CIColor(cgColor: UIColor(named: "sky2")!.cgColor)
        let bottomColor = CIColor(cgColor: UIColor(named: "sky3")!.cgColor)
        
        let texture = SKTexture(size: CGSize(width: self.frame.width, height: 5000), color1: topColor, color2: bottomColor)
        texture.filteringMode = .nearest
        let sprite = SKSpriteNode(texture: texture)
        sprite.position = CGPoint(x: self.frame.midX, y: 7000)
        sprite.size.width = self.frame.width
        sprite.size.height = CGFloat(5000)
        sprite.zPosition = -1
        addChild(sprite)
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.scaleMode = .aspectFill
        notificationCenter.addObserver(self,
                                       selector: #selector(self.applyImpulse),
                                       name: NSNotification.Name(NotificationName.CORRECT_ANSWER),
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.lowerTheBalloon),
                                       name: NSNotification.Name(NotificationName.FALSE_ANSWER),
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.knockOffTheBalloon),
                                       name: NSNotification.Name(NotificationName.END_GAME),
                                       object: nil)
        setBackground()
        addBackground()
        setCamera()
        setupFloor()
        balloon.spawn(on: self,
                      position: CGPoint(x: 40, y: 500),
                      size: CGSize(width: 70, height: 100))
        helicopter.spawn(on: self,
                         position: CGPoint(x: 200, y: 600),
                         size: CGSize(width: 142, height: 55))
        
        self.addCloudsAtRandomPositions()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if balloon.position.y < 440 {
            sceneCamera.position.y = 340
        } else {
            sceneCamera.position = CGPoint(x: balloon.position.x + 150,
                                           y: balloon.position.y - 100)
        }
    }
    
    func addCloudsAtRandomPositions() {
        // There are 100 clouds.
        // Set random cloud sizes while keeping aspect ratio for each of them.
        //
        for _ in 0..<100 {
            let cloud = SKSpriteNode(imageNamed: "cloud")
            cloud.size = CGSize(width: cloud.size.height * 1.8,
                                height: CGFloat(50))
            let yCoordinate = 300 + CGFloat(Int.random(in: 0...10000))
            cloud.position = CGPoint(x: CGFloat(Int.random(in: 0...300)),
                                     y: CGFloat(yCoordinate))
            cloud.zPosition = 1
            cloud.alpha = CGFloat.random(in: 0.50...1.0)
            self.addChild(cloud)
        }
      
    }
    
    @objc func applyImpulse() {
        balloon.refuel()
    }
    
    @objc func knockOffTheBalloon() {
        balloon.moveToFloor()
    }
    
    @objc func lowerTheBalloon() {
        balloon.lower()
    }
    
    func setupFloor() {
        let floorTexture = SKTexture(imageNamed: "ground")
        floor = SKSpriteNode(texture: floorTexture,
                             size: CGSize(width: self.frame.width, height: 100))
        floor.position = CGPoint(x: 0, y: 0)
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
