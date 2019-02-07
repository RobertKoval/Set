//
//  Set.swift
//  Set
//
//  Created by Robert on 04.02.19.
//  Copyright © 2019 Robert. All rights reserved.
//

import Foundation

class Set {
    private(set) var score = 0
    private var deck = Deck()
    private var onDeskCards : [Card] = []
    private(set) var selectedCards : [Card] = []
    
    func checkSet() -> Bool {
        if selectedCards.count == 3 {
            let setBySymbol = selectedCards.reduce(0, {$0 + $1.symbolId})
            let setByColor = selectedCards.reduce(0, {$0 + $1.colorId})
            let setByShading = selectedCards.reduce(0, {$0 + $1.shadingId})
            let setByNumber = selectedCards.reduce(0, {$0 + $1.numberId})
            let allSets = [setBySymbol, setByColor, setByShading, setByNumber]
            for number in allSets {
                if number % 3 != 0 {
                    selectedCards.removeAll()
                    score -= 2
                    return false
                }
            }
            score += 3
            selectedCards.forEach {
                if let index = onDeskCards.index(of: $0) {
                    onDeskCards.remove(at: index)
                }
            }
            selectedCards.removeAll()
            return true
        }
        return false
    }
    
    func selectCard(at index : Int) -> Int? {
        if index < 0 || index > onDeskCards.count - 1  {return nil}
        selectedCards.append(onDeskCards[index])
        return selectedCards.count
    }
    
    func deselectCard(at index : Int) {
        if let card = selectedCards.index(of: onDeskCards[index]), selectedCards.count > 0 {
            selectedCards.remove(at: card)
        }
    }
    
    func getCardData(at index : Int) -> Card? {
        if index < 0 || index > onDeskCards.count - 1 {return nil}
        return onDeskCards[index]
    }
    
    func cardsInDeck() -> Int {
        return deck.cards.count
    }
    
    func cardsOnDesk() -> Int {
        return onDeskCards.count
    }
    
    func addThreeCardsToDesk(){
        if onDeskCards.count >= 24 || deck.cards.count == 0 {return}
        for _ in 0..<3 {
            if let card = deck.getCardFromDeck() {
                onDeskCards.append(card)
            } else {return}
        }
    }
    
    func playNewGame() {
        score = 0
        deck = Deck()
        onDeskCards = []
        selectedCards = []
        for _ in 0..<4 {
            addThreeCardsToDesk()
        }
    }
    
    init() {
        for _ in 0..<4 {
            addThreeCardsToDesk()
        }
    }
    //TODO: hint method
    //TODO: timer
}
