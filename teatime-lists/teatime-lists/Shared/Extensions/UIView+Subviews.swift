//
//  UIView+Subviews.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import TinyConstraints

extension UIView {
    
    func addSubviewAndPin(_ view: UIView) {
        view.removeFromSuperview()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.edgesToSuperview()
    }
    
}
