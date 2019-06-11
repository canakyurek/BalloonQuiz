//
//  MainViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 5.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var playButtonContainer: ButtonContainer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var personalHighScoreLabel: UILabel!
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    @IBAction func unwindToMainSegue(_ sender: UIStoryboardSegue) {}
    var dualList = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if there is any saved list.
        // If not, obtain list.
        if let list = SaveUtil.loadList() {
            dualList = list
        } else {
            obtainQuestionList()
        }
        setupButtons()
        checkForPersonalHighscore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForPersonalHighscore()
    }
    
    func checkForPersonalHighscore() {
        let highscore = UserDefaults.standard.integer(forKey: "highscore")
        if  highscore != 0 {
            personalHighScoreLabel.text = "Kisisel rekor: \(highscore)"
        } else {
            personalHighScoreLabel.isHidden = true
        }
    }
    
    func setupButtons() {
        playButtonContainer.setTitle(as: "Oyna")
        playButtonContainer.setIconImage(named: .play)
        playButtonContainer.tapAction = { [weak self] in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: "startGameSegue", sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGameSegue" {
            if let destination = segue.destination as? GameViewController {
                destination.questions = dualList
            }
        }
    }

    private func obtainQuestionList() {
        let sequences = dataText.split(separator: "\n")
        var obtainedQuestion = ""
        var obtainedAnswers = [String]()
        
        // Start animating the activity indicator
        self.activityIndicator.startAnimating()
        
        // Obtain question word, correct answer and wrong ones.
        for dualToSplit in sequences.shuffled() {
            
            let dual = dualToSplit.split(separator: "*")
            let question = dual.first
            obtainedQuestion = String(question!)
            
            let answers = dual.last
            let answer = answers?.split(separator: ",").shuffled().first
            let answerText = String(answer!)
            
            for dualForWrongAnswers in sequences.shuffled() {
                let dual = dualForWrongAnswers.split(separator: "*")
                let question = dual.first
                let questionText = String(question!)
                if obtainedQuestion != questionText && obtainedAnswers.count < 2 {
                    let answers = dual.last
                    let falseAnswer = answers?.split(separator: ",").shuffled().first
                    obtainedAnswers.append(String(falseAnswer!))
                }
                continue
            }

            obtainedAnswers.append(answerText)
            let choices = obtainedAnswers.shuffled()
            let correctAnswer = choices.firstIndex(of: answerText)! + 1
            
            dualList.append(Question(word: obtainedQuestion,
                                     choices: choices,
                                     correctAnswer: correctAnswer))
            obtainedAnswers.removeAll(keepingCapacity: true)
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
        // Save the obtained list.
        SaveUtil.saveList(dualList)
    }
}
