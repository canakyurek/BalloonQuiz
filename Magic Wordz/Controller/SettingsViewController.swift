//
//  SettingsViewController.swift
//  Magic Words
//
//  Created by Can Akyurek on 13.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.2
            contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
            contentView.layer.masksToBounds = false
        }
    }
    
    @IBAction func unwindToSettings(_ sender: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocalizationStrings()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.setLocalizationStrings),
                                               name: NSNotification.Name(rawValue: NotificationName.LANGUAGE_DID_CHANGE),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "closeSettingsSegue", sender: self)
    }
    
    @objc private func setLocalizationStrings() {
        titleLabel.text = Localizable.Settings.title.localized
        howToPlayButton.setTitle(Localizable.Settings.howToPlay.localized,
                                 for: .normal)
        volumeButton.setTitle(Localizable.Settings.volume.localized,
                              for: .normal)
        languageButton.setTitle(Localizable.Settings.language.localized,
                                for: .normal)
    }
}
