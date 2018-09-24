//
//  PlaceIcon.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

class PlaceIcon: UIView {
    
    let mainImageContrainerView = UIView()
    let mainImageView = UIImageView()
    
    let iconImageContrainerView = UIView()
    let iconImageView = UIImageView()
    
    weak var parentMarker: PlaceMarker?

    // The Init method you need to use.
    convenience init(place: Place) {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 120))
        commonInit(place: place)
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    private func commonInit(place: Place) {
        
        mainImageContrainerView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        mainImageContrainerView.layer.cornerRadius = 30.0
        mainImageContrainerView.layer.shadowRadius = 3
        mainImageContrainerView.layer.shadowColor = UIColor.black.cgColor
        mainImageContrainerView.layer.shadowOpacity = 0.25
        mainImageContrainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        mainImageView.layer.cornerRadius = 30
        mainImageView.layer.borderWidth = 5
        mainImageView.layer.borderColor = UIColor.white.cgColor
        mainImageView.clipsToBounds = true
        mainImageContrainerView.addSubviewAndPin(mainImageView)
        
        iconImageContrainerView.frame = CGRect(x: 30, y: 55, width: 20, height: 20)
        iconImageContrainerView.backgroundColor = UIColor.iconBackground
        iconImageContrainerView.layer.cornerRadius = 10
        iconImageContrainerView.layer.borderColor = UIColor.white.cgColor
        iconImageContrainerView.layer.borderWidth = 1
        iconImageContrainerView.clipsToBounds = true
        
        iconImageContrainerView.addSubview(iconImageView)
        iconImageView.frame = CGRect(x: 5, y: 5, width: 10, height: 10)
        
        
        
        addSubview(mainImageContrainerView)
        addSubview(iconImageContrainerView)
        
        setImages(place: place)
    }
    
    
    private func setImages(place: Place) {
        iconImageView.image = place.categoryIcon
        iconImageView.tintImageColor(color: UIColor.white)
        
        mainImageView.kf.cancelDownloadTask()
        mainImageView.image = nil
        
        
        // Main Image (owner photo)
        if let urlString = place.followers.first?.photoURL,
            let url = URL(string: urlString) {
            mainImageView.kf.setImage(with: url) { [weak self] (_, _, _, _) in
                                self?.parentMarker?.tracksViewChanges = true
                                self?.parentMarker?.tracksViewChanges = false
            }
        }
    }
}
