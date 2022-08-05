//
//  CardBehavior.swift
//  Set
//
//  Created by 1C on 17/06/2022.
//

import UIKit

class CardBehavior: UIDynamicBehavior {

    var snapTo: CGPoint = CGPoint()

    private lazy var colisionBehavior: UICollisionBehavior = {
        
        let colisionBehavior = UICollisionBehavior()
        colisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        return colisionBehavior
        
    }()
    
    private lazy var itemBehavior: UIDynamicItemBehavior = {
       
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.allowsRotation = true
        itemBehavior.elasticity = 1.0
        itemBehavior.friction = 0.0
        itemBehavior.isAnchored = false
        
        return itemBehavior
        
    }()
    
    func push(_ item: UIDynamicItem) {
        
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        
        var multiplier = CGFloat(1)
        if UIScreen.main.traitCollection.verticalSizeClass == .regular, UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            multiplier = 2
        }
        
        push.magnitude = CGFloat(AnimationConstants.magnitude) * multiplier + CGFloat(3.0).arc4random
        push.angle = 2 * CGFloat.pi.arc4random
        push.action = { [ unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
        
    }
    
    func snap(_ item: UIDynamicItem) {
        let snapBehavior = UISnapBehavior(item: item, snapTo: snapTo)
        snapBehavior.damping = 0.3
        addChildBehavior(snapBehavior)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        
        colisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
                
    }
    
    func addItem(_ item: UIDynamicItem) {
        colisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
        Timer.scheduledTimer(withTimeInterval: AnimationConstants.timeCardsToFly, repeats: false) { [weak self] timer in
            self?.removeItem(item)
            self?.snap(item)
        }
    }
    
    override init() {
        super.init()
        addChildBehavior(colisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
    
        self.init()
        animator.addBehavior(self)
        
    }
    
}
