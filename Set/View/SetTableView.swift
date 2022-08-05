//
//  SetTable.swift
//  Set
//
//  Created by 1C on 21/05/2022.
//

import UIKit

//@IBDesignable
class SetTableView: UIView  {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var grid: Grid!
    
    private var cardsOnTheTable: Int {cardsView.count}

    var flyAwayCards: [SetCardView] = [] {
        willSet{
            removeSubviews(from: flyAwayCards)
        }
        didSet{
            addSubviews(from: flyAwayCards)
        }
    }
        
    var cardsView: [SetCardView] = []
    {
        willSet{
            removeSubviews(from: cardsView)
        }
        didSet {
            addSubviews(from: cardsView)
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
      
        grid = makeGridByAspectRatioStrategy(amountOfCards: cardsOnTheTable)
        
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: AnimationConstants.timeToAnimateFrameOfCard,
                    delay:  0.0,
                    options: [.curveEaseIn, .allowUserInteraction],
                    animations: {
                        if let frameForCard = self.grid[row, column] {
                            let cardView = self.cardsView[row*self.grid.dimensions.columnCount+column]
                            cardView.frame = frameForCard.insetBy(
                                dx: Constants.spacingBetweenCards,
                                dy: Constants.spacingBetweenCards)
                        }
                    }
                )
            }
        }
        
    }
            
    func addNewCards(_ newCards: [SetCardView]) {
        cardsView += newCards
        layoutIfNeeded()
//        setNeedsLayout()
    }
    
    func removeCards(_ cardsToDelete: [SetCardView]) {
        
        cardsToDelete.forEach {
            cardsView.remove(elements: [$0])
            $0.removeFromSuperview()
        }
        layoutIfNeeded()
//        setNeedsLayout()
    }
    
    private func removeSubviews(from cards: [SetCardView]) {
        for card in cards {
            card.removeFromSuperview()
        }
  //      layoutIfNeeded()
    }
    
    private func addSubviews(from cards: [SetCardView]) {
        for card in cards {
            addSubview(card)
        }
    //    layoutIfNeeded()
    }
    
    private func makeGridByAspectRatioStrategy(amountOfCards cellCount: Int) -> Grid {
        var grid = Grid(
            layout: Grid.Layout.aspectRatio(Constants.aspectRatioWithToHeightCard),
            frame: bounds
        )
        grid.cellCount = cellCount
        return grid
    }

    private struct Constants {
        static let aspectRatioWithToHeightCard = CGFloat(0.625)
        static let spacingBetweenCards = CGFloat(5.0)
    }
    
}

