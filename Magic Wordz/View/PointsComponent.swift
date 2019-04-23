//
//  PointsComponent.swift
//  Balloon
//
//  Created by Can Akyurek on 23.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

class PointsComponent: UIView {

    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadView()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("PointsComponent", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
}
