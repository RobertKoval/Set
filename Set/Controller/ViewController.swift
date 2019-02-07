//
//  ViewController.swift
//  Set
//
//  Created by Robert on 03.02.19.
//  Copyright © 2019 Robert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = Set()
    var cardElements : (symbols : String, colors : [UIColor]) = ("▲●■", [UIColor.red, .green, .blue])
    
    @IBOutlet weak var addThreeCardButton: UIButton!
    @IBOutlet var buttonViews: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var matchedCardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonViews.forEach {
            $0.backgroundColor = UIColor.fromInt(value: Int(0xFFFFFF))
            $0.addTarget(self, action: #selector(selectCard(_:)), for: .touchUpInside)
        }
        updateCardView()
    }
    
    func updateCardView() {
        addThreeCardButton.isEnabled = !(game.cardsOnDesk() >= 24 || game.cardsInDeck() == 0)
        if game.cardsOnDesk() < 12 && game.cardsInDeck() > 0 {
            game.addThreeCardsToDesk()
        }
        let cardsOnDesk = game.cardsOnDesk()
        for index in buttonViews.indices {
            if index < cardsOnDesk {
                if let card = game.getCardData(at: index) {
                    let characterIndex = cardElements.symbols.index(cardElements.symbols.startIndex, offsetBy: card.symbolId)
                    let color = cardElements.colors[card.colorId]
                    let title = String(cardElements.symbols[characterIndex]).over(times: card.numberId)
                    buttonViews[index].setAttributedTitle(titleGenerator(title: title, stroke: card.shadingId, color: color), for: .normal)
                    buttonViews[index].tintColor = color
                    buttonViews[index].isHidden = false
                }
            } else if index >= cardsOnDesk {
                buttonViews[index].setAttributedTitle(NSAttributedString(), for: .normal)
                buttonViews[index].isHidden = true
            }
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    func titleGenerator(title : String, stroke : Int, color : UIColor) -> NSAttributedString {
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.strokeWidth: stroke != 0 ? stroke * 4 : 0,
            NSAttributedStringKey.strokeColor : color,
            NSAttributedStringKey.foregroundColor : color,
            NSAttributedStringKey.strikethroughStyle : stroke == 1 ? NSUnderlineStyle.styleDouble.rawValue : NSUnderlineStyle.styleNone.rawValue,
            NSAttributedStringKey.strikethroughColor : color
        ]
        return NSAttributedString.init(string: title, attributes: attributes)
    }
    
    @IBAction func addThreeCards(_ sender: UIButton) {
        game.addThreeCardsToDesk()
        updateCardView()
    }
    
    @IBAction func playNewGame(_ sender: UIButton) {
        game.playNewGame()
        buttonViews.forEach{
            $0.isSelected = false
            $0.layer.borderWidth = 0
        }
        matchedCardButtons.forEach {
            $0.setAttributedTitle(NSAttributedString(), for: .normal)
        }
        updateCardView()
    }

    @objc func selectCard(_ sender: UIButton) {
        if sender.isSelected {
            sender.layer.borderWidth = 0
            sender.isSelected = false
            game.deselectCard(at: buttonViews.index(of: sender)!)
        } else if game.selectCard(at: buttonViews.index(of: sender)!) != nil {
            buttonViews.forEach {
                !$0.isSelected ? $0.layer.borderWidth = 0 : nil
            }
            sender.layer.borderWidth = 1.5
            sender.layer.borderColor = UIColor.green.cgColor
            sender.isSelected = true
        }
        if game.selectedCards.count == 3 {
            if game.checkSet() {
                var matchedCardsIndex = 0
                for button in buttonViews {
                    if button.isSelected == true {
                        button.isSelected = false
                        button.layer.borderWidth = 0
                        matchedCardButtons[matchedCardsIndex].setAttributedTitle(button.attributedTitle(for: .normal), for: .normal)
                        matchedCardsIndex += 1
                    }
                }
                //TODO: Sort by symbol count
            }
            else {
                for button in buttonViews {
                    if button.isSelected == true {
                        button.isSelected = false
                        button.layer.borderWidth = 1.5
                        button.layer.borderColor = UIColor.red.cgColor
                    }
                }
            }
        }
        updateCardView()
    }
}

extension String {
    func over(times : Int) -> String {
        var string = self
        for _ in 0..<times {
            string.append(self)
        }
        return string
    }
}

extension UIColor {
   class func fromInt(value : Int) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0))
    }
}


