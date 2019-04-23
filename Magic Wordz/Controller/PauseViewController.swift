//
//  PauseViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 23.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {

    @IBAction func resumeTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "resumeSegue", sender: self)
    }
    
    @IBAction func restartTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "restartSegue", sender: self)
    }
}
