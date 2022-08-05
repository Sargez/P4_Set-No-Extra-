//
//  Card.swift
//  Concentraton
//
//  Created by 1C on 27/03/2022.
//

import Foundation

struct Card: Hashable {
    
//    var hashValue: Int { return identifier }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs:Card, rhs:Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isMatched = false
    var isFaceUp = false
    var OpenedOnce = false
    private var identifier: Int
    
    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int {
        
        identifierFactory += 1
        return identifierFactory
        
    }
    
    init() {
        
        self.identifier = Card.getUniqueIdentifier()
        
    }
    
    
}

