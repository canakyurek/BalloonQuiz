//
//  BaseModel.swift
//  Balloon
//
//  Created by Can Akyurek on 2.04.2019.
//  Copyright © 2019 Can Akyurek. All rights reserved.
//

import Foundation

struct BaseModel: Codable {
    let status: Bool
    let msg: [Player]
}
