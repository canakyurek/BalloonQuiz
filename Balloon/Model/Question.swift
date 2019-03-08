//
//  Question.swift
//  Balloon
//
//  Created by Can Akyurek on 17.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import Foundation

class Question: NSObject, NSCoding {
    
    var word: String
    var choices = [String]()
    var correctAnswer: Int
    
    init(word: String,
         choices: [String],
         correctAnswer: Int) {
    
        self.word = word
        self.choices = choices
        self.correctAnswer = correctAnswer
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(word: "", choices: [""], correctAnswer: 0)
        
        self.word = aDecoder.decodeObject(forKey: "word") as! String
        self.choices = aDecoder.decodeObject(forKey: "choices") as! [String]
        self.correctAnswer = aDecoder.decodeInteger(forKey: "correctAnswer") as! Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(word, forKey: "word")
        aCoder.encode(choices, forKey: "choices")
        aCoder.encode(correctAnswer, forKey: "correctAnswer")
    }
}
