//
//  ActionButton.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

final class ActionButton: UIButton {

    convenience init() {
        self.init(type: .custom)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        layer.borderWidth = 1
        layer.cornerRadius = frame.size.height / 2
        titleLabel?.font = UIFont.poppinsSemiBold(fontSize: 14)
        layer.borderColor = UIColor.secondaryColor.cgColor
        self.setTitleColor(UIColor.secondaryColor, for: .normal)
        self.setTitleColor(UIColor.secondaryColor.darker(), for: UIControlState.highlighted)
    }
}
