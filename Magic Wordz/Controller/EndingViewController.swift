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
    var corrects: [Answer]!
    var wrongs: [Answer]!
    
    let leaderboardID = "highscores"
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var correctCountLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: CountingLabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    @IBAction func replayTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "replaySegue", sender: self)
    }
    
    @IBAction func wordListTapped(_ sender: UIButton) {
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = leaderboardID
        
        present(vc, animated: true, completion: nil)
       // self.performSegue(withIdentifier: "wordListSegue", sender: self)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wordListSegue" {
            let destination = segue.destination as! WordListViewController
            destination.corrects = corrects
            destination.wrongs = wrongs
        }
    }
    
    func postHighscore() {
        if GKLocalPlayer.local.isAuthenticated {
            highscoreValue = UserDefaults.standard.integer(forKey: "highscore")
            if score > highscoreValue {
                highscoreValue = score
                highscoreLabel.text = "\(highscoreValue)"
                let gkScore = GKScore(leaderboardIdentifier: leaderboardID)
                gkScore.value = Int64(score)
                GKScore.report([gkScore]) { error in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Score reported: \(self.score)")
                    }
                }
                UserDefaults.standard.set(highscoreValue, forKey: "highscore")
            }
        }
    }
}

extension EndingViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
