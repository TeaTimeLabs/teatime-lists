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
    
    let nameLabel = UILabel()
    
    weak var parentMarker: PlaceMarker?

    // The Init method you need to use.
    convenience init(place: Place) {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 110))
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
        iconImageContrainerView.layer.cornerRadius = iconImageContrainerView.frame.width / 2
        iconImageContrainerView.layer.borderColor = UIColor.white.cgColor
        iconImageContrainerView.layer.borderWidth = 1
        iconImageContrainerView.clipsToBounds = true
        
        iconImageContrainerView.addSubview(iconImageView)
        iconImageView.frame = CGRect(x: 5, y: 5, width: 10, height: 10)
        
        nameLabel.frame = CGRect(x: 0, y: 75, width: 80, height: 25)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.poppinsMedium(fontSize: 8)
        nameLabel.textColor = UIColor.middleTextColor
        nameLabel.text = place.name
        nameLabel.sizeToFit() // Needs to be after the Text
        nameLabel.frame = CGRect(x: 0, y: 75, width: 80, height: nameLabel.frame.height)
    
        
        addSubview(mainImageContrainerView)
        addSubview(iconImageContrainerView)
        addSubview(nameLabel)
        
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
                self?.refreshIconView()
            }
        }
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            iconImageContrainerView.backgroundColor = UIColor.primaryColor
            iconImageContrainerView.frame = CGRect(x: 23, y: 41, width: 34, height: 34)
            iconImageView.frame = CGRect(x: 7, y: 7, width: 20, height: 20)
            nameLabel.textColor = UIColor.black
            nameLabel.font = UIFont.poppinsMedium(fontSize: 12)
        } else {
            iconImageContrainerView.backgroundColor = UIColor.iconBackground
            iconImageContrainerView.frame = CGRect(x: 30, y: 55, width: 20, height: 20)
            iconImageView.frame = CGRect(x: 5, y: 5, width: 10, height: 10)
            nameLabel.textColor = UIColor.middleTextColor
            nameLabel.font = UIFont.poppinsMedium(fontSize: 8)
        }
        
        iconImageContrainerView.layer.cornerRadius = iconImageContrainerView.frame.width / 2
        nameLabel.sizeToFit() // Needs to be after the Text
        nameLabel.frame = CGRect(x: 0, y: 75, width: 80, height: nameLabel.frame.height)
        
        refreshIconView()
    }
    
    
    
    private func refreshIconView() {
        parentMarker?.tracksViewChanges = true
        parentMarker?.tracksViewChanges = false
    }
}
