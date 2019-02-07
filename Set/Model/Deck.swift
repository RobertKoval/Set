//
//  Deck.swift
//  Set
//
//  Created by Robert on 04.02.19.
//  Copyright © 2019 Robert. All rights reserved.
//

import Foundation

struct Deck {
    private(set) var cards : [Card] = []
    
    init() {
        for number in 0..<3 {
            for symbol in 0..<3 {
                for shading in 0..<3 {
                    for color in 0..<3 {
                        cards.append(Card(numberId: number, symbolId: symbol, shadingId: shading, colorId: color))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func getCardFromDeck() -> Card? {
        return cards.popLast()
        
    }
}

extension Int {
    var random : Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        return 0
    }
}

extension Array {
    mutating func shuffle() {
        for index in indices {
            let randomIndex = count.random
            let temp = self[randomIndex]
            self[randomIndex] = self[index]
            self[index] = temp
        }
    }
}
