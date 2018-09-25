//
//  MainViewController+Map.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

extension MainViewController {
    func addMapController() {
        mapViewController = MapViewController()
        mapViewController?.delegate = self
        add(mapViewController!, inside: view)
        view.sendSubview(toBack: mapViewController!.view)
    }
}

extension MainViewController: MapViewControllerDelegate {
    func didSelectMarker(place: Place?) {
        guard let place = place else {
            state = .drawer
            return
        }
        
        placeInfoViewController?.changeContent(place: place)
        state = .popover
    }
}
