//
//  EndingViewController.swift
//  Balloon
//
//  Created by Can Akyurek on 18.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class EndingViewController: UIViewController {

    var correctCount = 0
    
    @IBOutlet weak var correctCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        correctCountLabel.text = "\(correctCount)"
    }
    
    @IBAction func playAgainTapped(_ sender: UIButton) {

    }
}
