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
    
    let place: Place
    
    var isSelected = false {
        didSet {
            iconView = getIconView() // TO CHANGE TO iconView
        }
    }
    
//    let place: PLACETYPE
    
    init(place: Place) { // PLACETYPE
        self.place = place
        super.init()
        
        position = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long)
        iconView = getIconView()
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
        title = place.name
        tracksViewChanges = false
    }
    
    
    func getIconView() -> UIView {
        if isSelected {
            return PlaceIcon()
        } else {
            return PlaceIcon()
        }
    }
}
