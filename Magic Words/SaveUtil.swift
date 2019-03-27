//
//  SaveOperation.swift
//  Balloon
//
//  Created by Can Akyurek on 9.03.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import Foundation

class SaveUtil {
    
    static func saveList(_ list: [Question]) {
        let data = try! NSKeyedArchiver
            .archivedData(withRootObject: list, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "questions")
    }
    
    static func loadList() -> [Question]? {
        guard let data = UserDefaults.standard.data(forKey: "questions") else {
            return nil
        }
        return try! NSKeyedUnarchiver
            .unarchiveTopLevelObjectWithData(data) as? [Question]
    }
}
