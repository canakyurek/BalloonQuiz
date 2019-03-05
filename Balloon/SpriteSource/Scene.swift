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
        balloon.spawn(on: self,
                      position: CGPoint(x: 40, y: 500),
                      size: CGSize(width: 70, height: 100))
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc func applyImpulse() {
        balloon.refuel()
    }
    
    override func didEvaluateActions() {
        switch balloon.position.y {
        case 600...800:
            self.backgroundColor = UIColor(named: "green")!
        case 49...599:
            self.backgroundColor = UIColor(named: "lightBlue")!
        case 44...48:
            balloon.crash()
            sceneDelegate?.balloonDidCrash()
        default:
            print("game over")
        }
    }
}
