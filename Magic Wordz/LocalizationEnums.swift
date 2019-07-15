//
//  LocalizationEnums.swift
//  Balloon
//
//  Created by Can Akyurek on 28.06.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import Foundation

enum Localizable {
    enum MainMenu: String, LocalizableDelegate {
        case play = "kPlay"
        case personalRecord = "kPersonalRecord"
    }
    
    enum Settings: String, LocalizableDelegate {
        case title = "kSettings"
        case howToPlay = "kHowToPlay"
        case volume = "kVolume"
        case language = "kLanguage"
    }
    
    enum Pause: String, LocalizableDelegate {
        case title = "kPaused"
        case `continue` = "kContinue"
        case restart = "kRestart"
        case backToMenu = "kBackToMenu"
    }
    
    enum Ending: String, LocalizableDelegate {
        case score = "kScore"
        case highScore = "kHighScore"
        case flightTime = "kFlightTime"
        case correctCount = "kCorrectCount"
    }
    
    enum SideEndings: String, LocalizableDelegate {
        case leaderboard = "kLeaderboard"
        case wordList = "kWordList"
        case known = "kKnown"
        case unknown = "kUnknown"
        case gameCenterAuth = "kGameCenterAuthError"
    }
}

protocol LocalizableDelegate {
    var rawValue: String { get }
    var table: String? { get }
    var localized: String { get }
}

extension LocalizableDelegate {
    
    var languageBundle: Bundle {
        if let language = UserDefaults.standard.string(forKey: "language"),
            let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            return Bundle(path: path)!
        } else {
            return Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)!
        }
    }
    
    var localized: String {
        return languageBundle.localizedString(forKey: rawValue,
                                           value: nil,
                                           table: table)
        
    }
    
    var table: String? {
        return nil
    }
}
