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
    var score = 0
    var corrects: [Answer]!
    var wrongs: [Answer]!
    
    let leaderboardID = "highscores"
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: CountingLabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var highScoreTitleLabel: UILabel!
    @IBOutlet weak var flightTimeTitleLabel: UILabel!
    @IBOutlet weak var correctCountTitleLabel: UILabel!
    
    @IBAction func replayTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "replaySegue", sender: self)
    }
    
    @IBAction func wordListTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "wordListSegue", sender: self)
    }
    
    private func setLocalizationStrings() {
        scoreTitleLabel.text = Localizable.Ending.score.localized
        highScoreTitleLabel.text = Localizable.Ending.highScore.localized
        flightTimeTitleLabel.text = Localizable.Ending.flightTime.localized
        correctCountTitleLabel.text = Localizable.Ending.correctCount.localized
    }
    
    func setupAnimation() {
        let animation = Animation.named("confetti")
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalizationStrings()
        correctCountLabel.text = "\(correctCount)"
        scoreLabel.countFromZero(to: Float(score), duration: .brisk)
        if score != 0 {
            scoreLabel.completion = {
                self.setupAnimation()
            }
        }
        timerLabel.text = String(format: "%.1f", timerValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        postHighscore()
        setHighscore()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wordListSegue" {
            let destination = segue.destination as! WordListViewController
            destination.corrects = corrects
            destination.wrongs = wrongs
        }
    }
    
    func setHighscore() {
        highscoreValue = UserDefaults.standard.integer(forKey: "highscore")
        if score > highscoreValue {
            highscoreValue = score
            highscoreLabel.text = "\(highscoreValue)"
            UserDefaults.standard.set(highscoreValue, forKey: "highscore")
        }
    }
    
    func postHighscore() {
        if GKLocalPlayer.local.isAuthenticated {
            let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
            gkScore.value = Int64(score)
            GKScore.report([gkScore]) { error in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    
                }
            }
        }
    }
}

extension EndingViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
