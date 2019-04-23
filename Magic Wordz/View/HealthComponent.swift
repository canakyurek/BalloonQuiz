//
//  HeartsComponent.swift
//  Balloon
//
//  Created by Can Akyurek on 23.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit


class HealthComponent: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private var heartViews: [UIImageView]!
    
    @IBAction private func addTapped(_ sender: UIButton) {

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didLoseHealth(_:)),
                                               name: Notification.Name.init("FalseAnswer"),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("HealthComponent", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    @objc func didLoseHealth(_ notification: Notification) {
        guard let falseCounter = notification.userInfo?["falseCount"] as? Int,
            falseCounter < 4 else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.heartViews.reversed()[falseCounter - 1].transform = CGAffineTransform.init(scaleX: 2, y: 2)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.heartViews.reversed()[falseCounter - 1].transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }, completion: { _ in
                self.heartViews.reversed()[falseCounter - 1].image = UIImage(named: "emptyHeart")
            })
        }
    }
    
    func reloadView() {
        heartViews.forEach({ $0.image = UIImage(named: "fullHeart") })
    }
}
