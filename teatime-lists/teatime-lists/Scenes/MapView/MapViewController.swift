//
//  MapViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/19/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import GoogleMaps


final class MapViewController: UIViewController {
    
    private let mapView: GMSMapView
    
    init() {
        let latitude = LocationService.shared.rxLocation.value.latitude
        let longitude = LocationService.shared.rxLocation.value.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
        mapView.styleMap()
        mapView.isMyLocationEnabled = true
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
    }


}




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


