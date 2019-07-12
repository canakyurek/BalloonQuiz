//
//  AppDelegate.swift
//  Balloon
//
//  Created by Can Akyurek on 17.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var language = "tr"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        NotificationCenter.default.addObserver(
        forName: NSNotification.Name.init(NotificationName.LANGUAGE_DID_CHANGE),
        object: nil,
        queue: nil) { _ in
            self.language = UserDefaults.standard.value(forKey: "language") as! String
            self.refreshScreens()
        }
        
        return true
    }
    
    func refreshScreens() {
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}

