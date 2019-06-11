//
//  ViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 17.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import Instructions

class GameViewController: UIViewController {

    // MARK: - Outlet connections
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var choiceButtons: [UIButton]!
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var pointView: PointsComponent!
    @IBOutlet weak var healthView: HealthComponent!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var balloonCorridorView: UIView!
    @IBOutlet weak var choiceContainer: UIStackView!
    
    // MARK: - Variables
    var falseCounter = 0
    
    lazy var blurredView: UIView = {
        let blurredView = UIVisualEffectView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: self.view.frame.width,
                                               height: self.view.frame.height))
        let blurEffect = UIBlurEffect(style: .regular)
        blurredView.effect = blurEffect
        
        return blurredView
    }()
    
    var points = 0 {
        didSet {
            if points < 0 { points = 0 }
            setScoreLabel()
        }
    }
    var timerCounter = 0.0
    var timer: Timer!
    var questions: [Question]?
    var currentIndex = 0
    var correctCount = 0
    var interstitial: GADInterstitial!
    var balloonFrame: CGRect!
    
    var corrects = [Answer]()
    var wrongs = [Answer]()
    
    // MARK: - Constants
    
    let notificationCenter = NotificationCenter.default
    var coachMarksController: CoachMarksController?
    let pointOfInterest = UIView()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if questions != nil {
            configQuestionList()
        }
        
        // FIX: - Test ID used.
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.adSize = kGADAdSizeBanner
        bannerView.load(GADRequest())
        
        interstitial = createAndLoadInterstitial()
        notificationCenter.addObserver(self,
                                       selector: #selector(self.pauseGame),
                                       name: UIApplication.willResignActiveNotification,
                                       object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if the app launched for the first time.
        // If so, present coach mark.
        if UserDefaults.standard.bool(forKey: "hasLaunchedOnce") == false {
            UserDefaults.standard.set(true, forKey: "hasLaunchedOnce")
            setupCoachMarks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pauseButton.isEnabled = true
    }
    
    func setupCoachMarks() {
        coachMarksController = CoachMarksController()
        self.coachMarksController!.dataSource = self
        self.coachMarksController!.delegate = self
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Atla", for: .normal)
        self.coachMarksController!.skipView = skipView
        self.coachMarksController!.overlay.allowTap = true
        self.coachMarksController!.start(in: .window(over: self))
        sceneView.isPaused = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let controller = coachMarksController {
            controller.stop(immediately: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endGameSegue" {
            let vc = segue.destination as! EndingViewController
            vc.correctCount = currentIndex
            vc.score = points
            vc.timerValue = timerCounter
            vc.corrects = corrects
            vc.wrongs = wrongs
        }
    }
    
    func setScoreLabel() {
         pointView.pointLabel.text = "\(points)"
    }
    
    // MARK: - Ad methods
    
    func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func showInterstitialAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    // MARK: - Scene methods
    
    func setupScene() {
        let gameScene = Scene(delegate: self)
        sceneView.backgroundColor = SKColor.clear
        sceneView.ignoresSiblingOrder = true
        gameScene.size = sceneView.bounds.size
        sceneView.presentScene(gameScene)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(self.handleTimer),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func handleTimer() {
        timerCounter += 0.1
    }
   
    func askQuestion(at index: Int) {
        guard let questions = questions else { return }
        if questions.count > currentIndex {
            removeState()
            questionLabel.text = questions[index].word
            for (i, button) in choiceButtons.enumerated() {
                button.setTitle(questions[index].choices[i].uppercased(), for: .normal)
            }
        }
        else {
            performSegue(withIdentifier: "endGameSegue", sender: self)
        }
    }
    
    func configQuestionList() {
        if questions != nil {
            currentIndex = 0
            falseCounter = 0
            points = 0
            healthView.reloadView()
            questions = questions!.shuffled()
            setupScene()
            startTimer()
            askQuestion(at: currentIndex)
        }
    }
    
    func removeState() {
        for button in choiceButtons {
            button.backgroundColor = UIColor(named: "secondaryButtonColor")
            button.setTitleColor(.darkGray, for: .normal)
            button.isEnabled = true
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard var questions = questions else { return }
        choiceButtons.forEach({ $0.isEnabled = false })
        if questions[currentIndex].correctAnswer == sender.tag {
            notificationCenter
                .post(name: Notification.Name("CorrectAnswer"), object: nil)
            sender.backgroundColor = UIColor(named: "green")
            sender.setTitleColor(UIColor(named: "secondaryButtonColor"), for: .normal)
            
            let answer = Answer(originalWord: questions[currentIndex].word,
                                correctAnswer: sender.currentTitle!)
            corrects.append(answer)
            
            questions.remove(at: currentIndex)
            currentIndex += 1
            points += 10
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
                guard let `self` = self else { return }
                self.askQuestion(at: self.currentIndex)
            }
            
        } else {
            falseCounter += 1
            let userInfo = ["falseCount": falseCounter]
            notificationCenter.post(name: Notification.Name("FalseAnswer"),
                                    object: nil,
                                    userInfo: userInfo)
            self.view.layoutIfNeeded()
            sender.backgroundColor = UIColor(named: "red")
            sender.setTitleColor(UIColor(named: "secondaryButtonColor"), for: .normal)
            
            let answer = Answer(originalWord: questions[currentIndex].word,
                                correctAnswer: sender.currentTitle!)
            wrongs.append(answer)
            let tag = questions[currentIndex].correctAnswer
            self.view.viewWithTag(tag)?.backgroundColor = UIColor(named: "green")
            (self.view.viewWithTag(tag) as! UIButton)
                .setTitleColor(UIColor(named: "secondaryButtonColor"), for: .normal)
            points -= 10
            if falseCounter < 3 {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    questions.remove(at: self.currentIndex)
                    self.currentIndex += 1
                    self.askQuestion(at: self.currentIndex)
                }
            } else {
                endGame()
            }
        }
    }
    
    func endGame() {
        guard var questions = questions else { return }
        stopTimer()
        let tag = questions[currentIndex].correctAnswer
        self.view.viewWithTag(tag)?.backgroundColor = UIColor(named: "green")
        (self.view.viewWithTag(tag) as! UIButton)
            .setTitleColor(UIColor(named: "secondaryButtonColor"), for: .normal)
        notificationCenter.post(name: Notification.Name("EndGame"), object: nil)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.balloonDidCrash()
        }
    }
    
    @IBAction func unwindToGameScene(_ sender: UIStoryboardSegue) {
        if sender.identifier == "replaySegue" {
            configQuestionList()
        } else if sender.identifier == "resumeSegue" {
            blurredView.isHidden = true
            sceneView.isPaused = false
        } else if sender.identifier == "restartSegue" {
            blurredView.isHidden = true
            sceneView.isPaused = false
            configQuestionList()
        }
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        pauseGame()
    }
    
    @objc func pauseGame() {
        sceneView.isPaused = true
        if self.view.subviews.contains(blurredView) {
            blurredView.isHidden = false
        } else {
            self.view.addSubview(blurredView)
        }
        performSegue(withIdentifier: "pauseSegue", sender: nil)
    }
}

// MARK: - GameSceneDelegate methods

extension GameViewController: GameSceneDelegate {
    func balloonDidCrash() {
        stopTimer()
        choiceButtons.forEach({ $0.isEnabled = false })
        self.pauseButton.isEnabled = false
        guard var questions = questions else { return }
        let tag = questions[currentIndex].correctAnswer
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { [weak self] _ in
            guard let `self` = self else { return }
            self.view.viewWithTag(tag)?.backgroundColor = UIColor(named: "green")
            (self.view.viewWithTag(tag) as! UIButton)
                .setTitleColor(UIColor(named: "secondaryButtonColor"), for: .normal)
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: "endGameSegue", sender: self)
        }
    }
}

// MARK: - GADInterstitialDelegate methods

extension GameViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        self.performSegue(withIdentifier: "endGameSegue", sender: self)
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        self.performSegue(withIdentifier: "endGameSegue", sender: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        self.performSegue(withIdentifier: "endGameSegue", sender: self)
    }
    
}


