//
//  InterfaceBuilder+Localization.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

protocol UIElementLocalization {
    var localizationKey: String? { get set }
}

extension UILabel: UIElementLocalization {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: UIElementLocalization {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}
