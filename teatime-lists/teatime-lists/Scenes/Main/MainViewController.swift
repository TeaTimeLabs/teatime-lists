//
//  MainViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/17/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MainViewController: UIViewController {

    var mapViewController: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = LocationService.shared.rxLocation.value

        mapViewController = MapViewController()
        add(mapViewController!, inside: view)
    }
}
