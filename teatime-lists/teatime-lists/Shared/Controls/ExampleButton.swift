//
//  ExampleButton.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit


@IBDesignable
class DButton: UIButton {
    
    enum DButtonStyle: Int {
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
    
    var buttonStyle: DButtonStyle = .main {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var style: Int {
        get {
            return buttonStyle.rawValue
        }
        set {
            buttonStyle = DButtonStyle(rawValue: newValue) ?? .main
        }
    }
    
    convenience init(frame: CGRect, style: DButtonStyle) {
        self.init(frame: frame)
        buttonStyle = style
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    func setStyle() {
        let buttonColor = self.buttonStyle.getColor()
        
        layer.borderWidth = 1
        layer.cornerRadius = frame.size.height / 2
        titleLabel?.font = UIFont(name: "Nunito-Bold", size: titleLabel?.font.pointSize ?? 16.0)
        layer.borderColor = buttonColor.cgColor
        self.setTitleColor(buttonColor, for: .normal)
        self.setTitleColor(buttonColor.darker(), for: UIControlState.highlighted)
        self.setTitleColor(UIColor.gray, for: UIControlState.disabled)   // UIColor.dDisabledControlColor()
    }
    
    override var isEnabled:Bool {
        didSet {
            if isEnabled {
                layer.borderColor = self.buttonStyle.getColor().cgColor
            } else {
                layer.borderColor = UIColor.gray.cgColor //UIColor.dDisabledControlColor().cgColor
            }
        }
    }
}
