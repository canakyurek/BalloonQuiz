//
//  Routable.swift
//  Balloon
//
//  Created by Can Akyurek on 28.06.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit

protocol Routable {
    associatedtype ControllerIdentifier: RawRepresentable
}

extension Routable where Self: UIViewController, ControllerIdentifier.RawValue == String {
    
    func show(controller: ControllerIdentifier) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: controller.rawValue)
        
        show(vc, sender: self)
    }
}
