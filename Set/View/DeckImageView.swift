//
//  DeckImageView.swift
//  Set
//
//  Created by 1C on 09/06/2022.
//

import UIKit

//@IBDesignable
class DeckImageView: UIImageView {

    @IBInspectable
    var amountCardsInDeck: Int = 81 {
        didSet{
            setNeedsLayout()
        }
    }
    
    private var deckCountLabel = UILabel(){
        didSet{
            setNeedsLayout()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsLayout()
    }
    
    private func centerAttributedString() -> NSAttributedString {
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize).bold()
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.alignment = .center
                
        let attributedString = NSAttributedString.init(string: String(amountCardsInDeck),
                                                       attributes: [.font: font,
                                                        .paragraphStyle: paragraphStyle])
        
        
        return attributedString
    }
    
    private func configureDeckLabel() {
        deckCountLabel.numberOfLines = 1
        deckCountLabel.attributedText = centerAttributedString()
        deckCountLabel.adjustsFontForContentSizeCategory = true
        deckCountLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        deckCountLabel.frame.size = CGSize.zero
        deckCountLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        
        configureDeckLabel()
        
        deckCountLabel.frame.origin = CGPoint(x: bounds.midX, y: bounds.midY/2)
        deckCountLabel.frame = deckCountLabel.frame.offsetBy(dx: -labelOffset, dy: 0)
        
        addSubview(deckCountLabel)
    }
    
}

extension DeckImageView {
    private struct Constants {
        static let ratioOffset: CGFloat = 0.15
        static let ratioFontSizeToWithImageView: CGFloat = 0.3
    }
    
    private var labelOffset: CGFloat {
        return bounds.width * Constants.ratioOffset
    }
    
    var fontSize: CGFloat {
        return bounds.height * Constants.ratioFontSizeToWithImageView
    }
    
}

extension UIFont {
    func withTraits(trait: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(trait)
        return UIFont(descriptor: descriptor!, size: 0)
    }
    func bold() -> UIFont {
        return withTraits(trait: .traitBold)
    }
}

