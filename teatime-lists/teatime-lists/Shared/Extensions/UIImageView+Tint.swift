//
//  UIImageView+Tint.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/24/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    func tintImageColor(color : UIColor) {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
}
