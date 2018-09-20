//
//  UIColor+Manipulation.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

// MARK: - Custom Colors from Assets Calalog
extension UIColor {
    
    static var primaryColor: UIColor? {
        return UIColor(named: "PrimaryColor")
    }
    
    static var secondaryColor: UIColor? {
        return UIColor(named: "SecondaryColor")
    }
    
    static var lightTextColor: UIColor? {
        return UIColor(named: "LightTextColor")
    }
    
    static var darkTextColor: UIColor? {
        return UIColor(named: "DarkTextColor")
    }
    
}


// MARK: - Color manipulations
extension UIColor {
    func darker() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    func lighter() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        
        return UIColor()
    }
}
