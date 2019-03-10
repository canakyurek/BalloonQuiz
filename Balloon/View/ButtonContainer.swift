//
//  Button.swift
//  Balloon
//
//  Created by Can Akyurek on 5.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

enum IconName: String {
    case play = "play"
    case settings = "settings"
    case replay = "replay"
}
class ButtonContainer: UIView {
    
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var imageView: UIImageView!
    
    var tapAction: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Bundle.main.loadNibNamed("ButtonContainer", owner: self, options: nil)
        self.frame = contentView.frame
        self.addSubview(contentView)
        
        setupLayer()
    }
    
    func setTitle(as title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func setIconImage(named name: IconName) {
        let image = UIImage(named: name.rawValue)
        imageView.image = image
    }
    
    private func setupLayer() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).cgColor
        self.layer.borderWidth = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        tapAction?()
    }
}
