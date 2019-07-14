//
//  CategoryCell.swift
//  Balloon
//
//  Created by Can Akyurek on 18.06.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var dotImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.14)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        containerView.layer.cornerRadius = 62.5
        containerView.clipsToBounds = true
    }
    
    var isFirst = false {
        didSet {
            dotImageView.isHidden = isFirst
        }
    }
}
