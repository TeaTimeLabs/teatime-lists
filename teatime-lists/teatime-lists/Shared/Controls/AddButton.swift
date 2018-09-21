//
//  AddButton.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

class AddButton: UIButton {

    enum AddButtonStyle: Int {
        case main = 0
        case secondary = 1
        
        func getColor() -> UIColor {
            switch self {
            case .main:
                return UIColor.darkGray //UIColor.dDarkButtonColor()
            case .secondary:
                return UIColor.lightGray //UIColor.dLightButtonColor()
            }
        }
    }

}
