//
//  EndingViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 18.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class EndingViewController: UIViewController {

    var correctCount = 0
    var timerValue = 0.0
    var highscoreValue = 0
    
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    @IBAction func replayTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "replayGameSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        correctCountLabel.text = "\(correctCount)"
        scoreLabel.text = "\(correctCount)"
        timerLabel.text = String(format: "%.1f", timerValue)
        setHighscoreText()
    }
    
    func setHighscoreText() {
        highscoreValue = UserDefaults.standard.integer(forKey: "highscore")
        if correctCount > highscoreValue {
            highscoreValue = correctCount
            UserDefaults.standard.set(highscoreValue, forKey: "highscore")
        }
        highscoreLabel.text = "\(highscoreValue)"
    }
}
