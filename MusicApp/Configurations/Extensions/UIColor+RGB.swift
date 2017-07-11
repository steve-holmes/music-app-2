//
//  UIColor+GlobalColors.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init?(hexFormat format: String) {
        let length = format.characters.count
        
        switch length {
        case 6:
            let rawRed = format.substring(with: format.startIndex ..< format.index(format.startIndex, offsetBy: 2))
            let rawGreen = format.substring(with: format.index(format.startIndex, offsetBy: 2) ..< format.index(format.startIndex, offsetBy: 4))
            let rawBlue = format.substring(with: format.index(format.endIndex, offsetBy: -2) ..< format.endIndex)
            
            guard let red = Int(rawRed, radix: 16), let green = Int(rawGreen, radix: 16), let blue = Int(rawBlue, radix: 16) else {
                return nil
            }
            
            self.init(withIntRed: red, green: green, blue: blue)
        case 8:
            let rawRed = format.substring(with: format.startIndex ..< format.index(format.startIndex, offsetBy: 2))
            let rawGreen = format.substring(with: format.index(format.startIndex, offsetBy: 2) ..< format.index(format.startIndex, offsetBy: 4))
            let rawBlue = format.substring(with: format.index(format.endIndex, offsetBy: -4) ..< format.index(format.endIndex, offsetBy: -2))
            let rawAlpha = format.substring(with: format.index(format.endIndex, offsetBy: -2) ..< format.endIndex)
            
            guard let red = Int(rawRed, radix: 16), let green = Int(rawGreen, radix: 16), let blue = Int(rawBlue, radix: 16), let alpha = Int(rawAlpha, radix: 16) else {
                return nil
            }
            
            self.init(withIntRed: red, green: green, blue: blue, alpha: alpha)
        default:
            return nil
        }
    }
    
}

extension UIColor {
    
    convenience init(withIntRed red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: 1
        )
    }
    
    convenience init(withIntRed red: Int, green: Int, blue: Int, alpha: Int) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
}

extension UIColor {
    
    convenience init(withIntWhite white: Int) {
        self.init(white: CGFloat(white) / 255, alpha: 1)
    }
    
    convenience init(withIntWhite white: Int, alpha: Int) {
        self.init(white: CGFloat(white) / 255, alpha: CGFloat(alpha) / 255)
    }
    
}
