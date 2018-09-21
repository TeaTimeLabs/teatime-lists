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
    @IBOutlet var searchBarView: SearchBarView!
    @IBOutlet var floatingButton: FloatingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = LocationService.shared

        searchBarView?.delegate = self
        addMapController()
        // TODO: make a static method on it to instantiate
        addDrawerController(with: ListBrowserViewController(nibName: "ListBrowserViewController", bundle: nil))
        
        view.bringSubview(toFront: floatingButton)
    }
    
    @IBAction func addListTapped(_ sender: Any) {
        present(storyboard: .listEditing)
    }
}

