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
    @IBOutlet weak var settingsButtonContainer: ButtonContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playButtonContainer.tapAction = {
            self.performSegue(withIdentifier: "startGameSegue", sender: self)
        }
    }
}
