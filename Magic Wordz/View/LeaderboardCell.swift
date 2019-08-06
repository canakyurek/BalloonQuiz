//
//  LeaderboardCell.swift
//  Balloon
//
//  Created by Can Akyurek on 3.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
