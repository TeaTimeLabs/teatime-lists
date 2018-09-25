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
    let placeIcon: PlaceIcon
    
    var isSelected = false {
        didSet {
            if oldValue != isSelected {
                placeIcon.setSelected(isSelected)
            }
        }
    }
    
    init(place: Place) {
        self.place = place
        self.placeIcon = PlaceIcon(place: place)
        
        super.init()
        
        position = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long)
        
        placeIcon.parentMarker = self
        iconView = placeIcon
        
        groundAnchor = CGPoint(x: 0.5, y: 0.60)
        appearAnimation = .pop
        tracksViewChanges = false
    }
}
