
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
    
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init("LanguageDidChange"),
                                        object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = Localizable.Settings.language.localized
    }
}
