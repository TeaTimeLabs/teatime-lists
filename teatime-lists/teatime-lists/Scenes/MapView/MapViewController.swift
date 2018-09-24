//
//  MapViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/19/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps



final class MapViewController: UIViewController {
    
    let defaultZoom: Float = 16.0
    
    let mapView: GMSMapView
    
    var markers = Set<PlaceMarker>()
    
    
    init() {
        let latitude = LocationService.shared.rxLocation.value.latitude
        let longitude = LocationService.shared.rxLocation.value.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: defaultZoom)
        mapView = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
        mapView.styleMap()
        mapView.isMyLocationEnabled = true
        
        super.init(nibName: nil, bundle: nil)
        mapView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        
        
        // DEBUG: Remove
        let marker = PlaceMarker(place: 0)
        markers.insert(marker)
        marker.map = mapView
    }

    
    func setMapBottomPadding(_ padding: CGFloat) {
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
    }
    
    func centerOnUserLocation(zoom: Float? = nil) {
        guard let latitude = mapView.myLocation?.coordinate.latitude,
            let longitude = mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom ?? defaultZoom)
        mapView.animate(to: camera)
    }
}


extension MapViewController: GMSMapViewDelegate {
    // tap map marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // remove color from currently selected marker
        if let selectedMarker = mapView.selectedMarker {
            selectedMarker.icon = GMSMarker.markerImage(with: nil)
        }
        
        // select new marker and make green
        mapView.selectedMarker = marker
        (marker as? PlaceMarker)?.isSelected = true
        
//        selectedMarker.value = marker
        
        // tap event handled by delegate
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        markers.forEach({ $0.isSelected = false})
        
        mapView.selectedMarker = nil
//        selectedMarker.value = nil
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


