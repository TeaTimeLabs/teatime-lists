//
//  FloatingButton.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {

    enum FloatingButtonStyle: Int {
        case add = 0
        case edit = 1
        case comment = 2
        
        func getColor() -> UIColor {
            return UIColor.primaryColor
        }
        
        func getIcon() -> UIImage {
            switch self {
            case .add:
                return #imageLiteral(resourceName: "icnAdd")
            case .edit:
                return #imageLiteral(resourceName: "icnEdit")
            case .comment:
                return #imageLiteral(resourceName: "icnChat")
            }
        }
    }
    
    
    var buttonStyle: FloatingButtonStyle = .add {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var style: Int {
        get {
            return buttonStyle.rawValue
        }
        set {
            buttonStyle = FloatingButtonStyle(rawValue: newValue) ?? .add
        }
    }
    
    convenience init(style: FloatingButtonStyle) {
        self.init(type: .custom)
        buttonStyle = style
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    func setStyle() {
        backgroundColor = buttonStyle.getColor()
        layer.cornerRadius = frame.size.height / 2
        setImage(buttonStyle.getIcon(), for: .normal)
        
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        clipsToBounds = false
    }
    
    override var isEnabled:Bool {
        didSet {
//            if isEnabled {
//                layer.borderColor = self.buttonStyle.getColor().cgColor
//            } else {
//                layer.borderColor = UIColor.gray.cgColor //UIColor.dDisabledControlColor().cgColor
//            }
        }
    }

}
