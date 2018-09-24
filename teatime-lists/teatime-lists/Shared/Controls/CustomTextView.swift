//
//  CustomTextView.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/14/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

import Foundation
import UIKit
import GrowingTextView

@IBDesignable class CustomTextView: GrowingTextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset.left = 0
        textContainer.lineFragmentPadding = 0
    }
}
