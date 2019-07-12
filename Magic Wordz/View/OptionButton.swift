//
//  OptionButton.swift
//  Balloon
//
//  Created by Can Akyurek on 12.07.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class OptionButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set (cornerRadius) {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
            animate(transform)
        }
    }
    
    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: [.curveEaseInOut],
            animations: {
                self.transform = transform
            }
        )
    }
}
