//
//  UIFont+Custom.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/19/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit


extension UIFont {
    class func poppinsSemiBold(fontSize: CGFloat = 28.0) -> UIFont? {
        return UIFont(name: "Poppins-SemiBold", size: fontSize)
    }
    
    class func poppinsMedium(fontSize: CGFloat = 16.0) -> UIFont? {
        return UIFont(name: "Poppins-Medium", size: fontSize)
    }
    
    class func poppinsRegular(fontSize: CGFloat = 14.0) -> UIFont? {
        return UIFont(name: "Poppins-Regular", size: fontSize)
    }
}
