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
    
    override func didMove(to view: SKView) {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.backgroundColor = .clear
        notificationCenter.addObserver(self,
                                       selector: #selector(self.applyImpulse),
                                       name: NSNotification.Name("CorrectAnswer"),
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.explodeBalloon),
                                       name: NSNotification.Name("FalseAnswer"),
                                       object: nil)
        balloon.spawn(on: self,
                      position: CGPoint(x: 40, y: 500),
                      size: CGSize(width: 70, height: 100))
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.position.y < self.frame.height * 0.6 {
            self.position.y = self.frame.height * 0.6
        }
    }
    
    @objc func applyImpulse() {
        balloon.refuel()
    }
    
    @objc func explodeBalloon() {
        balloon.moveToFloor()
    }
    
    override func didEvaluateActions() {
        switch balloon.position.y {
        case 0...5:
            balloon.crash()
            sceneDelegate?.balloonDidCrash()
        default:
            self.backgroundColor = UIColor(named: "lightBlue")!
        }
    }
}
