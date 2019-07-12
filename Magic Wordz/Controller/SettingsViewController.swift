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
    
    @IBAction func unwindToSettings(_ sender: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocalizationStrings()
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "closeSettingsSegue", sender: self)
    }
    
    private func setLocalizationStrings() {
        titleLabel.text = Localizable.Settings.title.localized
        howToPlayButton.setTitle(Localizable.Settings.howToPlay.localized,
                                 for: .normal)
        volumeButton.setTitle(Localizable.Settings.volume.localized,
                              for: .normal)
        languageButton.setTitle(Localizable.Settings.language.localized,
                                for: .normal)
    }
}
