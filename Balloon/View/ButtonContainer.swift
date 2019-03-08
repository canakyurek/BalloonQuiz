//
//  Button.swift
//  Balloon
//
//  Created by Can Akyurek on 5.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class ButtonContainer: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBInspectable public var buttonTitle: String = "" {
        didSet {
            title = buttonTitle
        }
    }
    
    var tapAction: (() -> Void)? = nil
    var title = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Bundle.main.loadNibNamed("ButtonContainer", owner: self, options: nil)
        self.frame = contentView.frame
        self.addSubview(contentView)
        imageView.image = UIImage(named: "indicator")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).cgColor
        self.layer.borderWidth = 4
        button.setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        tapAction?()
    }
}
