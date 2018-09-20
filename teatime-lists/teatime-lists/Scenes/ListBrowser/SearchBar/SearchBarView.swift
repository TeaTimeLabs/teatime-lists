//
//  SearchBarView.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/19/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import TinyConstraints

@IBDesignable

class SearchBarView: UIView {

    private let leftIconImageView = UIImageView()
    private let searchTextField = UITextField()
    private let nearbyButton = UIButton(type: UIButtonType.custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.shadowRadius = 2.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.24
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        addSubview(leftIconImageView)
        addSubview(searchTextField)
        addSubview(nearbyButton)
        
        leftIconImageView.edgesToSuperview(excluding: .trailing)
        nearbyButton.edgesToSuperview(excluding: .leading)
        nearbyButton.width(50.0)
        searchTextField.topToSuperview()
        searchTextField.bottomToSuperview()
        leftIconImageView.rightToLeft(of: searchTextField)
        leftIconImageView.width(50.0)
        searchTextField.rightToLeft(of: nearbyButton)
        
        searchTextField.setHugging(.defaultLow, for: .horizontal)
        searchTextField.placeholder = "Nearby"
        searchTextField.textColor = UIColor.darkTextColor
        searchTextField.font = UIFont.poppinsRegular()
        
        leftIconImageView.image = #imageLiteral(resourceName: "icnSearch")
        leftIconImageView.contentMode = .center
        nearbyButton.setImage(#imageLiteral(resourceName: "icnLocate"), for: .normal)
    }
    
}
