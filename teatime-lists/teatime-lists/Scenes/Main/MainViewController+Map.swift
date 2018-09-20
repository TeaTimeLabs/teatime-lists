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
        add(mapViewController!, inside: view)
        view.sendSubview(toBack: mapViewController!.view)
    }
}
