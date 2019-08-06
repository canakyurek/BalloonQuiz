//
//  PauseViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 23.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.2
            contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
            contentView.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocalizationStrings()
    }
    
    func setLocalizationStrings() {
        titleLabel.text = Localizable.Pause.title.localized
        continueButton.setTitle(Localizable.Pause.continue.localized,
                                for: .normal)
        restartButton.setTitle(Localizable.Pause.restart.localized,
                                             for: .normal)
        backToMenuButton.setTitle(Localizable.Pause.backToMenu.localized,
                                  for: .normal)
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "resumeSegue", sender: self)
    }
    
    @IBAction func restartTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "restartSegue", sender: self)
    }
    
    @IBAction func menuTapped(_ sender: UIButton) {
        show(controller: .mainMenu)
    }
}

extension PauseViewController: Routable {
    enum ControllerIdentifier: String {
        case mainMenu = "MainViewController"
    }
}
