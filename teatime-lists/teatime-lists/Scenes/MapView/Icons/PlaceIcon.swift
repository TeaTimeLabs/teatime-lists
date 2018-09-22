//
//  PlaceIcon.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

class PlaceIcon: UIView {
    
    let mainImageView = UIImageView()
    let iconImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 70))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        mainImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        mainImageView.layer.cornerRadius = 30
        mainImageView.layer.borderWidth = 5
        mainImageView.layer.borderColor = UIColor.white.cgColor
        mainImageView.clipsToBounds = true
        
        mainImageView.image = #imageLiteral(resourceName: "raja")
        addSubview(mainImageView)
    }

}
