//
//  ViewController.swift
//  Set
//
//  Created by 1C on 30/04/2022.
//

import UIKit

class SetController: UIViewController, UIDynamicAnimatorDelegate {

//    override var vclLoggingName: String {return "SetController"}
    
    var game = Game()
        
    private var deckCount: Int {game.deck.cards.count}
    private var scoreCount: Int {
        game.matchedCards.count/3
    }
    private var scoreHints = 0 {didSet {updateHintsTitle()}}
    @IBOutlet weak var imageViewDeck: DeckImageView! {
        didSet{
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(dealCardsByTap(_:)))
            tap.numberOfTapsRequired = 1
            
            imageViewDeck.addGestureRecognizer(tap)
            
        }
    }
    
    @IBOutlet weak var setsCount: UIButton!
    
    private weak var timerForHints: Timer?
    
    @IBOutlet weak var setTableView: SetTableView! {
        didSet{
        
            let swipeUp = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeUpHandlerOfViewControler(_:)))
            swipeUp.direction = .up
            
            let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateCardsOnTheTable(_:)))
            
            setTableView.addGestureRecognizer(rotate)
            setTableView.addGestureRecognizer(swipeUp)
            
        }
    }
    
    private lazy var animator = UIDynamicAnimator(referenceView: setTableView)
    
    private lazy var cardBehavior = CardBehavior.init(in: animator)
    
    @IBOutlet private weak var hints: ManageButtonsView! {didSet {updateHintsTitle()}}
    
    @IBAction func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended :
            deal3Cards()
        default:
            break
        }
    }
        
    @objc func dealCardsByTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            deal3Cards()
        default:
            break
        }
    }
    
    @objc func touchCard(_ recognizer: UITapGestureRecognizer) {

        switch recognizer.state {
        case .ended :
            if let cardView = (recognizer.view as? SetCardView), cardView.isFaceUp, let card = cardView.setCard {
                timerForHints?.fire()
                game.selectCard(card)
                updateViewFromModel()
                dealAnimation()
            }
        default:
            break
        }

    }
    
    @IBAction func newGame(_ sender: ManageButtonsView) {
        newGame()
    }
    
    private func newGame() {
        setTableView.removeCards(setTableView.cardsView)
        game = Game()
        updateViewFromModel()
        dealAnimation()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateViewFromModel()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dealAnimation()
        animator.delegate = self
        cardBehavior.snapTo = discardPileCenter
    }
    
    private var cardsToDeal: [SetCardView] {
        setTableView.cardsView.filter {$0.alpha == 0.0}
    }
    
    private var matchedCardsView: [SetCardView] {
        return setTableView.cardsView.filter {$0.isMatched}
    }
    
    private var justFlyAwayCards: [SetCardView] {
        return setTableView.cardsView.filter {$0.alpha >= CGFloat(AnimationConstants.alphaForCardsDuringFlyAway) && $0.alpha < 1}
    }
    
    private var discardPileCenter: CGPoint {
        return mainStack.convert(setsCount.center, to: setTableView)
    }
    
    private var discardPileRect: CGRect {
        return mainStack.convert(setsCount.frame, to: setTableView)
    }
    
    private func cardIsAlreadyAtDiscardPile(_ cardView: SetCardView) -> Bool {
        return Int(discardPileCenter.x) == Int(cardView.center.x) || Int(discardPileCenter.y) == Int(cardView.center.y)
    }
    
    @IBOutlet weak var mainStack: UIStackView!
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        
        setTableView.flyAwayCards.forEach {cardView in
            if cardIsAlreadyAtDiscardPile(cardView) {
                cardView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin,.flexibleLeftMargin,.flexibleRightMargin]
                UIView.transition(with: cardView,
                                  duration: 2*AnimationConstants.timeToFlipOverCard,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    cardView.isFaceUp = false
                                    cardView.frame = self.discardPileRect
                                  },
                                  completion: {position in
                                    self.cardBehavior.removeItem(cardView)
                                    self.setTableView.flyAwayCards.remove(elements: [cardView])
                                    cardView.removeFromSuperview()
                                  }
                )
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.cardBehavior.snapTo = self.discardPileCenter
        }, completion: { context -> Void in
//            print("disCardPile center: \(self.discardPileCenter)")
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        cardBehavior.snapTo = discardPileCenter
        
    }
    
    private func flyAwayAnimation() {

        if game.isSet {
            
            let bufferMatchedCard = matchedCardsView
            
            bufferMatchedCard.forEach { cardView in
                if !justFlyAwayCards.contains(cardView) {
                    let tempCard = cardView.makeCopy(from: cardView)
                    setTableView.flyAwayCards.append(tempCard)

                    cardBehavior.addItem(tempCard)
                }
            }
                        
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 2.0,
                delay: 0.0,
                options: [.curveEaseInOut, .allowUserInteraction],
                animations: {
                        bufferMatchedCard.forEach { cardView in
                            if !self.justFlyAwayCards.contains(cardView) {
//                                cardView.isMatched = false
                                cardView.alpha = CGFloat(AnimationConstants.alphaForCardsDuringFlyAway)
                            }
                        }
                    }
            )
        } else {
            justFlyAwayCards.forEach {
                $0.alpha = 0.0
                $0.isFaceUp = false
                
            }
        }
    }
    
    func dealAnimation() {
        
        if !cardsToDeal.isEmpty {
            Timer.scheduledTimer(withTimeInterval: AnimationConstants.timeToAnimateFrameOfCard,
                                                         repeats: false) { [weak self] timer in
                //1. переместим карты к сдаче (алфа=0) на колоду
                //2. сделаем карты видимыми на колоде (алфа=1)
                var delayConst: TimeInterval = 0
                self?.cardsToDeal.forEach {[weak self] cardView in
                    if !cardView.isMatched {
                        
                        delayConst += 1
                        
                        let cardFrame = cardView.frame
                        cardView.frame.origin = CGPoint(x: self!.setTableView.frame.midX, y: self!.setTableView.frame.maxY)
                        cardView.alpha = 1.0
                        
                        //3. анимируем фрейм карт согласно грид.
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: AnimationConstants.timeToDealAnimation,
                            delay: delayConst * 0.5,
                            options: [.curveEaseInOut],
                            animations: {
                                cardView.frame = cardFrame
                            },
                            completion: { position in
                                switch position {
                                case .end:
                                    UIView.transition(with: cardView,
                                                      duration: AnimationConstants.timeToFlipOverCard,
                                                      options: [.transitionFlipFromLeft],
                                                      animations: {
                                                        cardView.isFaceUp = true
                                                        
                                                      })
                                default: break
                                }
                            }
                        )
                    }
                }
            }
        }
        
// примитивная анимация с анимирующим св-вом альфа
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 2.0,
//            delay: AnimationConstants.timeToAnimateFrameOfCard,
//            options: [.curveEaseInOut, .allowUserInteraction],
//            animations: {
//                self.cardsToDeal.forEach {cardView in
//                    if !cardView.isMatched {
//                        cardView.alpha = 1
//                    }
//                }
//            }
//        )
    }
    
    @objc private func rotateCardsOnTheTable(_ recognizer: UIRotationGestureRecognizer) {
        
        switch recognizer.state {
        case .ended:
            game.rotateCardsOnTheTable()
            updateViewFromModel()
        default:
            break
        }
                
    }
    
    @objc private func swipeUpHandlerOfViewControler(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            newGame()
        default:
            break
        }
    }
    
    private func deal3Cards() {
        if deckCount > 0 {
            game.deal3Cards()
            updateViewFromModel()
            dealAnimation()
        }
    }
        
    private func updateViewFromModel() {
        
        updateCardsFromModel()
        
        flyAwayAnimation()
        
        imageViewDeck.amountCardsInDeck = deckCount
        imageViewDeck.alpha = deckCount == 0 ? 0 : 1
        setsCount.alpha = scoreCount == 0 ? 0 : 1
        if scoreCount > 0 {
            updateSetsCountTitle()
        }
        scoreHints = game.findAllSetsOnTheTable().count
        hints.isEnabled = scoreHints > 0

        if game.isGameOver() {
            updateCardsFromModel()
        }
    }
              
    private func updateCardsFromModel() {
        
        var cardsToAppend: [SetCardView] = []
        
        if game.cardsOnTheTable.count < setTableView.cardsView.count {
            setTableView.removeCards(matchedCardsView)
        }
        
        for index in game.cardsOnTheTable.indices {
            
            let cardModel = game.cardsOnTheTable[index]
            
            if index > (setTableView.cardsView.count - 1) {
                //создаем новые карты
                let cardView = SetCardView()
                translateCard(model: cardModel, to: cardView)
                cardView.alpha = 0.0
                cardView.isFaceUp = false
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(touchCard(_:)))
                tap.numberOfTapsRequired = 1
                cardView.addGestureRecognizer(tap)
                
                cardsToAppend.append(cardView)
                
            } else {
                //обновляем карты
                let cardView = setTableView.cardsView[index]
                translateCard(model: cardModel, to: cardView)
                
            }
                        
        }
        
        setTableView.addNewCards(cardsToAppend)
          
    }
    
    private func translateCard(model cardModel: SetCard, to cardView: SetCardView) {
        cardView.setCard = cardModel
        cardView.count = cardModel.amount.rawValue
        cardView.symbolInt = cardModel.type.rawValue
        cardView.colorInt = cardModel.color.rawValue
        cardView.fillInt = cardModel.fill.rawValue
        cardView.isSelected = game.isSelected(this: cardModel)
        cardView.isMatched = game.isMatched(this: cardModel)
        cardView.isDismatched = game.isDismatched(this: cardModel)
    }
    
    private func updateSetsCountTitle() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(imageViewDeck.fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font).bold()
        
        let attributedString = NSAttributedString.init(string: "Sets: \(scoreCount)",
                                                       attributes: [.font: font, .paragraphStyle: paragraphStyle])
        
        setsCount.setAttributedTitle(attributedString, for: UIControl.State.normal)
 
    }
    
    @IBAction private func showMeSet(_ sender: ManageButtonsView) {
        timerForHints?.invalidate()
        if let setToShow = game.findAllSetsOnTheTable().randomElement() {
            setTableView.cardsView.forEach { cardView in
                if let card = cardView.setCard, setToShow.contains(card) {
                    cardView.isHinted = true
                } else {
                    cardView.isHinted = false
                }
            }
            timerForHints = Timer.scheduledTimer(withTimeInterval: TimeInterval(Constants.flashingTime), repeats: false) {
                [weak self] timer in
                self!.setTableView.cardsView.forEach { cardView in
                    cardView.isHinted = false
                }
            }
        }
    }
    
    private func updateHintsTitle() {
        hints.setTitle("Hints:\(scoreHints)", for: UIControl.State.normal)
    }
    
    private struct Constants {
        static let flashingTime = 3.0
    }
    
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(Int32(self))))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(Int32(abs(self)))))
        } else {
            return 0
        }
    }
}

