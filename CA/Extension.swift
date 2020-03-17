//
//  Extension.swift
//  CA
//
//  Created by 顏淩育 on 2020/3/16.
//  Copyright © 2020 顏淩育. All rights reserved.
//

import UIKit

let screen = UIScreen.main.bounds.size
let screenScaleWidth = screen.width / 414
let screenSceleHeight = screen.height / 736

enum WordSpace: CGFloat {
    case onePFive, onePEightThree, onePNine, twoPTwo, twoPThreeThree, twoPFiveSeven, fourPZero, fourPSixEight, fivePZero
    
    
    
}

class Extension: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

extension NSAttributedString {
    
    // wordSpace字距
    static func setAttributedString(string: String, wordSpace: WordSpace) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string)
        var kernValue: CGFloat = 0
        switch wordSpace {
        case .fourPSixEight:
            kernValue = 4.67
        case .onePFive:
            kernValue = 1.5
        case .onePEightThree:
            kernValue = 1.83
        case .onePNine:
            kernValue = 1.9
        case .twoPTwo:
            kernValue = 2.2
        case .twoPThreeThree:
            kernValue = 2.33
        case .twoPFiveSeven:
            kernValue = 2.57
        case .fourPZero:
            kernValue = 4.0
        case .fivePZero:
            kernValue = 5.0
            
        }
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    // wordSpace字距，並且不同顏色
    static func setDiffrentColorAttrStr(string: String, wordSpace: WordSpace, color: UIColor, interval: Int) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string)
        var kernValue: CGFloat = 0
        switch wordSpace {
        case .fourPSixEight:
            kernValue = 4.67
        case .onePFive:
            kernValue = 1.5
        case .onePEightThree:
            kernValue = 1.83
        case .onePNine:
            kernValue = 1.9
        case .twoPTwo:
            kernValue = 2.2
        case .twoPThreeThree:
            kernValue = 2.33
        case .twoPFiveSeven:
            kernValue = 2.57
        case .fourPZero:
            kernValue = 4.0
        case .fivePZero:
            kernValue = 5.0
        }
        
        let wordCount = string.count - "\(interval)".count
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: NSRange(location: 0, length: wordCount))
        return attributedString
    }
}

extension UIColor {
    static func set(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static func setMyYellow() -> UIColor {
        return UIColor(red: 1, green: 214 / 255, blue: 0, alpha: 1)
    }
    
    static func setMyGray() -> UIColor {
        return UIColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
    }
    
    static func setMyLightMustard() -> UIColor {
        return UIColor(red: 253.0 / 255.0, green: 203.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightMustard: UIColor {
      return UIColor(red: 253.0 / 255.0, green: 203.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }
    
    //返回隨機顏色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
