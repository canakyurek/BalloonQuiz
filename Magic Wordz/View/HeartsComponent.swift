//
//  HeartsComponent.swift
//  Balloon
//
//  Created by Can Akyurek on 23.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

protocol HealthDelegate {
    
}

class HeathComponent: UIView {

    @IBOutlet weak var contentView: UIView!
    
    @IBAction func addTapped(_ sender: UIButton) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadView()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("HeartsComponent", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
}
