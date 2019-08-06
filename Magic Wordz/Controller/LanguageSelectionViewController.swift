
//
//  LanguageSelectionViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 1.07.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var languageKey = ""
    
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            languageKey = "en"
        case 2:
            languageKey = "tr"
        default:
            break
        }
        UserDefaults.standard.setValue(languageKey, forKey: "language")
        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.LANGUAGE_DID_CHANGE),
                                        object: nil)
        titleLabel.text = Localizable.Settings.language.localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = Localizable.Settings.language.localized
    }
}

extension LanguageSelectionViewController: Routable {
    enum ControllerIdentifier: String {
        case mainMenu = "MainViewController"
    }
}
