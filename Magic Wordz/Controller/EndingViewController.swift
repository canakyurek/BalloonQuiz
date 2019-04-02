//
//  EndingViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 18.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import GameKit

class EndingViewController: UIViewController {

    var correctCount = 0
    var timerValue = 0.0
    var highscoreValue = 0
    
    let leaderBoardID = "highscores"
    
    
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel! {
        didSet {
            setHighscoreText()
        }
    }
    
    @IBAction func replayTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "replayGameSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        correctCountLabel.text = "\(correctCount)"
        scoreLabel.text = "\(correctCount)"
        timerLabel.text = String(format: "%.1f", timerValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        postHighscore()
    }
    
    func setHighscoreText() {
        highscoreValue = UserDefaults.standard.integer(forKey: "highscore")
        if correctCount > highscoreValue {
            highscoreValue = correctCount
            UserDefaults.standard.set(highscoreValue, forKey: "highscore")
        }
        highscoreLabel.text = "\(highscoreValue)"
    }
    
    func postHighscore() {
        if GKLocalPlayer.local.isAuthenticated {
            highscoreValue = UserDefaults.standard.integer(forKey: "highscore")
            if correctCount > 0 {
                highscoreValue = correctCount
                let gkScore = GKScore(leaderboardIdentifier: leaderBoardID)
                gkScore.value = Int64(correctCount)
                GKScore.report([gkScore]) { error in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Score reported: \(self.correctCount)")
                    }
                }
                UserDefaults.standard.set(highscoreValue, forKey: "highscore")
            }
            
        }
    }
}
