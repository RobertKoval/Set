//
//  Card.swift
//  Set
//
//  Created by Robert on 04.02.19.
//  Copyright © 2019 Robert. All rights reserved.
//

import Foundation

struct Card : Equatable, CustomStringConvertible {
    var numberId : Int
    var symbolId : Int
    var shadingId : Int
    var colorId : Int
    
    var description: String {
        return "Number: \(numberId), symbol: \(symbolId), shading: \(shadingId), color: \(colorId)\n"
    }
}
