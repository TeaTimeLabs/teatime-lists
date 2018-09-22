//
//  PlaceMarker.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps

final class PlaceMarker: GMSMarker {
    
    var isSelected = false {
        didSet {
            iconView = getIconView() // TO CHANGE TO iconView
        }
    }
    
//    let place: PLACETYPE
    
    init(place: Int = 0) { // PLACETYPE
//        self.place = place
        super.init()
        
        position = defaultMapLocation
//        icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
    
    
    func getIconView() -> UIView {
        if isSelected {
            return PlaceIcon()
        } else {
            return PlaceIcon()
        }
    }
}
