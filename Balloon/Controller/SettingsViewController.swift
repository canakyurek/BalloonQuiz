//
//  SettingsViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 13.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func dismissTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "closeSettingsSegue", sender: self)
    }
    
    @IBAction func removeAdsTapped(_ sender: UIButton) {
        let controller = UIAlertController(title: nil,
                                           message: "Kaldıramazsan kaldırırlar gülüm.",
                                           preferredStyle: .alert)
        let action = UIAlertAction(title: "Peki",
                                   style: .default,
                                   handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
}
