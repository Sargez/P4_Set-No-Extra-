//
//  Deck.swift
//  Set
//
//  Created by 1C on 30/04/2022.
//

import Foundation

struct Deck {
        
   var cards = [SetCard]()
        
   init() {
    for amount in SetCard.Variants.allCases {
            for type in SetCard.Variants.allCases {
                for color in SetCard.Variants.allCases {
                    for fill in SetCard.Variants.allCases {
                        cards.append(SetCard(type: type, amount: amount, fill: fill, color: color))
                    }
                }
            }
        }
        
    }
    
}


