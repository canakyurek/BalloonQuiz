//
//  MainViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 5.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var buttonsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var playButtonContainer: ButtonContainer!
    @IBOutlet weak var settingsButtonContainer: ButtonContainer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    var dualList = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setOperation()
        
        playButtonContainer.tapAction = { [weak self] in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: "startGameSegue", sender: self)
        }
    }
    
    func setOperation() {
        self.activityIndicator.startAnimating()
        let operationQueue = OperationQueue()
        let completion = BlockOperation { [weak self] in
            guard let `self` = self else { return }
            self.presentButtons()
        }
        let operation = BlockOperation { [weak self] in
            guard let `self` = self else { return }
            self.obtainQuestionList()
        }
        
        operationQueue.addOperation(operation)
        completion.addDependency(operation)
        OperationQueue.main.addOperation(completion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGameSegue" {
            if let destination = segue.destination as? GameViewController {
                destination.questions = dualList
            }
        }
    }
    
    private func presentButtons() {
        UIView.animate(withDuration: 5,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseIn,
                       animations: {
                        self.buttonsBottomConstraint.constant = 400
        }, completion: nil)
    }

    private func obtainQuestionList() {
        let sequences = dataText.split(separator: "\n")
        var obtainedQuestion = ""
        var obtainedAnswers = [String]()
        
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
        //SaveUtil.saveList(dualList)
    }
}
