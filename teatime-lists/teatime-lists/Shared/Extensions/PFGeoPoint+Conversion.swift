//
//  PFGeoPoint+Conversion.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/26/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import Parse


extension PFGeoPoint {
    var asCLCoordinate2D : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
