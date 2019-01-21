//
//  Words.swift
//  Balloon
//
//  Created by Can Akyurek on 17.01.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import Foundation


let q1 = Question.init(word: "food",
                       choices: ["su", "yemek", "çıkış"],
                       correctAnswer: 2)

let q2 = Question.init(word: "bond",
                       choices: ["bağ", "tel", "sınır"],
                       correctAnswer: 1)

var questions: [Question] {
    return [q1, q2, q1, q2, q1]
}
