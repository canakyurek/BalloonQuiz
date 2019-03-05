//
//  ViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 17.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var choiceButtons: [UIButton]!
    @IBOutlet weak var sceneView: SKView!
    
    @IBAction func unwindToGameScene(_ sender: UIStoryboardSegue) {
        if let _ = sender.source as? EndingViewController {
            self.viewDidLoad()
        }
    }
    
    var currentIndex = 0
    var correctCount = 0
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameScene = Scene(delegate: self)
        sceneView.backgroundColor = SKColor.clear
        sceneView.ignoresSiblingOrder = true
        gameScene.size = sceneView.bounds.size
        sceneView.presentScene(gameScene)
        
        askQuestion(at: currentIndex)
    }
    
    func removeState() {
        for button in choiceButtons {
            button.backgroundColor = UIColor(named: "blue")
        }
    }
    
    func askQuestion(at index: Int) {
        if questions.count > currentIndex + 1 {
            removeState()
            questionLabel.text = questions[index].word
            for (i, button) in choiceButtons.enumerated() {
                button.setTitle(questions[index].choices[i], for: .normal)
            }
        }
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if questions[currentIndex].correctAnswer == sender.tag {
            notificationCenter
                .post(name: Notification.Name("CorrectAnswer"), object: nil)
            sender.backgroundColor = UIColor(named: "green")
            currentIndex += 1
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
                guard let `self` = self else { return }
                self.askQuestion(at: self.currentIndex)
            }
            
        } else {
            notificationCenter
                .post(name: Notification.Name("FalseAnswer"), object: nil)
            sender.backgroundColor = UIColor(named: "red")
            let tag = questions[currentIndex].correctAnswer
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
                guard let `self` = self else { return }
                self.view.viewWithTag(tag)?.backgroundColor = UIColor(named: "green")
            }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
                guard let `self` = self else { return }
                self.performSegue(withIdentifier: "endGameSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endGameSegue" {
            let vc = segue.destination as! EndingViewController
            vc.correctCount = currentIndex
        }
    }
}

extension GameViewController: GameSceneDelegate {
    func balloonDidCrash() {
        performSegue(withIdentifier: "endGameSegue", sender: self)
    }
}
