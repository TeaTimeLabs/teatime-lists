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
    var drawerViewController: DrawerViewController?
    @IBOutlet var searchBarView: SearchBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = LocationService.shared

        searchBarView?.delegate = self
        addMapController()
        addDrawerController(with: ListBrowserViewController(nibName: "ListBrowserViewController", bundle: nil))
    }
}

