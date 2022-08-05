//
//  ConcentrationThemeChooser.swift
//  Set
//
//  Created by 1C on 19/06/2022.
//

import UIKit

class ConcentrationThemeChooser: UIViewController, UISplitViewControllerDelegate {

    private var lastSeguedCvc: ConcentrationViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        if let _ = (secondaryViewController as? ConcentrationViewController) {
            return true
        }
        return false

    }
    
    @IBAction func touchThemeButton(_ sender: UIButton) {
        
        if let cvc = splitViewController?.viewControllers.last as? ConcentrationViewController {
                
            if let indexButton = themeButtons.firstIndex(of: sender) {
                cvc.theme = themes[indexButton + 1] ?? nil
            }
        }
        else if let cvc = lastSeguedCvc {
            
            if let indexButton = themeButtons.firstIndex(of: sender) {
                cvc.theme = themes[indexButton + 1] ?? nil
            }
            
            navigationController?.pushViewController(cvc, animated: true)
            
        }
            
        else {
                   
            performSegue(withIdentifier: "themeChoose", sender: sender)
        
        }
    }
    
    @IBOutlet var themeButtons: [UIButton]!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier, identifier == "themeChoose" {
            if let cvc = segue.destination as? ConcentrationViewController, let button = sender as? UIButton {
                if let indexButton = themeButtons.firstIndex(of: button) {
                    cvc.theme = themes[indexButton + 1] ?? nil
                    lastSeguedCvc = cvc
                }
            }
        }
    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//
//
//
//    }

//    private func getIdentifier(_ sender: UIButton) -> String? {
//
//        var id: String?
//        if let index = themeButtons.firstIndex(of: sender) {
//            id = keys[Int(index)]
//        }
//        return id
//
//    }
    
    private var themes: [Int: (name: String, emojies: [String], backColorOfCard: UIColor, backGroundView: UIColor)] = [
        1: ("Hallowen", ["🎃","👻","😈","🧛","🧙‍♀️","🙀","🌙","🌚","⚡️", "💀"], #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        2: ("Fruits", ["🍎","🍋","🍒","🍇","🥝","🍌","🥥","🍍","🍐", "🍊"], #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),
        3: ("Sports", ["⚽️","🏀","🏈","🎾","🏓","🏸","🥊","🛹","⛸", "🛼"], #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        4: ("Transports", ["🚗","🚕","🛴","✈️","🚠","🚜","🚑","🚂","🛥", "🏎"], #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)),
        5: ("Flags", ["🚩","🇩🇿","🇦🇿","🇧🇬","🇨🇿","🇱🇷","🇳🇮","🇺🇸","🇫🇷", "🇩🇪"], #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        6: ("Smiles", ["😃","😆","😂","😛","🥸","😡","🥳","😍","😤", "🥶"], #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        7: ("Animals", ["🦧","🐘","🐫","🐈","🦜","🐩","🦔","🐖","🐎","🐄"], #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
    ]
//    private var keys: [String] {
//        return Array(themes.keys)
//    }
    
}
