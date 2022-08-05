//
//  ViewController.swift
//  Concentraton
//
//  Created by 1C on 27/03/2022.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfCardsPair: numberOfCardsPair)
    
    @IBOutlet private weak var FlipCountLabel: UILabel!
    @IBOutlet weak var ScoreCountLabel: UILabel!
    @IBOutlet private var cardsButton: [UIButton]!
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    
    var numberOfCardsPair: Int {
        return (cardsButton.count/2)+1
    }
    
    var theme: (name: String, emojies: [String], backColorOfCard: UIColor, backGroundView: UIColor)? {
        didSet {
            emojies.removeAll()
            emojiAtCard.removeAll()
            emojies = theme?.emojies ?? [""]
            backGroundColor = theme?.backGroundView
            backColorOfCard = theme?.backColorOfCard
            themeName = theme?.name
            
            updateViewFromTheme()
            refreshUIView()
        }
    }
    
    private var backGroundColor: UIColor?
    private var backColorOfCard: UIColor?
    private var emojies = [""]
    private var themeName: String?
        
    private var backGroundView: UIColor {
        backGroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    private var backColor: UIColor {
        backColorOfCard ?? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
    private var emojiAtCard = [Card: String]()
        
    private func Emoji(for card: Card) -> String {
                
        if emojiAtCard[card] == nil, emojies.count > 0 {
            emojiAtCard[card] = emojies.remove(at: emojies.count.arc4random)
        }
        
        return emojiAtCard[card] ?? "?"
        
    }
        
//    private var currentNumberOfTheme = 0 {
//        didSet{
//            emojiAtCard.removeAll()
//            emojies = themes[keys[currentNumberOfTheme]]?.emojies ?? []
//            updateTitle()
//            updateViewFromTheme()
//        }
//    }
    
    @IBAction private func NewGame(_ sender: UIButton) {
        
//        currentNumberOfTheme = keys.count.arc4random

        game = Concentration(numberOfCardsPair: numberOfCardsPair)
        
        updateViewFromTheme()
        refreshUIView()

    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        currentNumberOfTheme = keys.count.arc4random
        refreshUIView()
        updateViewFromTheme()
    }
    
    private func updateViewFromTheme() {
        view.backgroundColor = backGroundView
        for index in cardsButton.indices {
            cardsButton[index].backgroundColor = backColor
        }
        updateNewGameButton()
        updateTitle()
    }
    
    private func updateNewGameButton() {
        NewGameButton.setTitleColor(backColor, for: UIControl.State.normal)
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeColor: backColor,
            .strokeWidth: 5.0
        ]
        let attributedString = NSAttributedString.init(string: "New game", attributes: attributes)
        NewGameButton.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: backColor
        ]
        let attributedString = NSAttributedString.init(string: "Flip count: \(game.flipCount)", attributes: attributes)
        FlipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreLabel() {
        let NSAattributes: [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : backColor
        ]
        let NSAstring = NSAttributedString.init(string: "Score:\(game.score)", attributes: NSAattributes)
        ScoreCountLabel.attributedText = NSAstring
    }
    
    private func updateTitle() {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeColor : backColor,
            .strokeWidth : 5.0
        ]
        let NSAstring = NSAttributedString.init(string: "\(themeName ?? "")", attributes: attributes)
        TitleLabel.attributedText = NSAstring
        
    }
        
    @IBAction private func touchCard(_ sender: UIButton) {
        
        if let index = cardsButton.firstIndex(of: sender) {
            game.chooseCard(at: index)
            refreshUIView()
        } else {
            print("Chosen card is not in array cardsButton")
        }
        
    }

    private func refreshUIView()  {
        
        for index in cardsButton.indices {
            let card = game.cards[index]
            let cardButton = cardsButton[index]
            
            if card.isFaceUp {
                cardButton.setTitle(Emoji(for: card), for: UIControl.State.normal)
                cardButton.backgroundColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cardButton.setTitle("", for: UIControl.State.normal)
                cardButton.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : backColor
            }
        }
        updateFlipCountLabel()
        updateScoreLabel()
        
    }
                    
}

//Extensions
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(Int32(self))))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(Int32(abs(self)))))
        } else {
            return 0
        }
    }
}
