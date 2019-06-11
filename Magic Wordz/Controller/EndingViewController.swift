//
//  EndingViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 18.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import GameKit
import Lottie

class EndingViewController: UIViewController {

    var correctCount = 0
    var timerValue = 0.0
    var highscoreValue = 0
    var score = 0
    let leaderBoardID = "highscores"
    
    var corrects: [Answer]!
    var wrongs: [Answer]!
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: CountingLabel!
    @IBOutlet weak var highscoreLabel: UILabel! {
        didSet {
            setHighscoreText()
        }
    }
    
    @IBAction func replayTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "replaySegue", sender: self)
    }
    
    @IBAction func wordListTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "wordListSegue", sender: self)
    }
    
    func setupAnimation() {
        let animation = Animation.named("confetti")
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        correctCountLabel.text = "\(correctCount)"
        scoreLabel.countFromZero(to: Float(score), duration: .brisk)
        scoreLabel.completion = {
            self.setupAnimation()
        }
        timerLabel.text = String(format: "%.1f", timerValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        postHighscore()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wordListSegue" {
            let destination = segue.destination as! WordListViewController
            destination.corrects = corrects
            destination.wrongs = wrongs
        }
        
    }
    
    func setHighscoreText() {
        highscoreValue = UserDefaults.standard.integer(forKey: "highscore")
        if score > highscoreValue {
            highscoreValue = score
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
