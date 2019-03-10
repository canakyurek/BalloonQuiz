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
    @IBOutlet weak var replayButtonContainer: ButtonContainer!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        correctCountLabel.text = "\(correctCount)"
        setupButton()
    }
    
    func setupButton() {
        replayButtonContainer.setTitle(as: "Replay")
        replayButtonContainer.setIconImage(named: .replay)
        replayButtonContainer.tapAction = { [weak self] in
            guard let `self` = self else { return }
            self.performSegue(withIdentifier: "replayGameSegue", sender: self)
        }
    }
}
