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
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBAction func unwindToGameScene(_ sender: UIStoryboardSegue) {
        if let _ = sender.source as? EndingViewController {
            currentIndex = 0
            viewDidLoad()
        }
    }
    
    var questions: [Question]?
    var currentIndex = 0
    var correctCount = 0
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if questions != nil {
            questions = questions!.shuffled()
            counterLabel.text = "\(currentIndex + 1)/\(questions!.count)"
            let gameScene = Scene(delegate: self)
            sceneView.backgroundColor = SKColor.clear
            sceneView.ignoresSiblingOrder = true
            gameScene.size = sceneView.bounds.size
            sceneView.presentScene(gameScene)
            
            askQuestion(at: currentIndex)
        }
      //  try! NSKeyedArchiver.archivedData(withRootObject: questions,
      //                               requiringSecureCoding: false)
        
    }
    
    func removeState() {
        for button in choiceButtons {
            button.backgroundColor = UIColor(named: "blue")
            button.isEnabled = true
        }
    }
    
    func askQuestion(at index: Int) {
        guard let questions = questions else { return }
        if questions.count > currentIndex {
            counterLabel.text = "\(currentIndex + 1)/\(questions.count + 1)"
            removeState()
            questionLabel.text = questions[index].word
            for (i, button) in choiceButtons.enumerated() {
                button.setTitle(questions[index].choices[i], for: .normal)
            }
        }
        else {
            performSegue(withIdentifier: "endGameSegue", sender: self)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard var questions = questions else { return }
        choiceButtons.forEach({ $0.isEnabled = false })
        if questions[currentIndex].correctAnswer == sender.tag {
            notificationCenter
                .post(name: Notification.Name("CorrectAnswer"), object: nil)
            sender.backgroundColor = UIColor(named: "green")
            questions.remove(at: currentIndex)
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
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
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
