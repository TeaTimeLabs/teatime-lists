//
//  MapViewController+Style.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/25/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import GoogleMaps

extension GMSMapView {
    func styleMap() {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "UltraLight", withExtension: "json") {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
    }
}
