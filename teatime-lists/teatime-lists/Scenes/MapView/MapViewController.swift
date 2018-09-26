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

protocol MapViewControllerDelegate: class {
    func didSelectMarker(place: Place?)
}



final class MapViewController: UIViewController {
    
    weak var delegate: MapViewControllerDelegate?
    
    let defaultZoom: Float = 15.0
    let mapView: GMSMapView
    var markers = Set<PlaceMarker>()

    // Make a unique search marker for search and pin

    var places: Set<Place>? {
        didSet {
            updateMarkers()
        }
    }
    
    
    init() {
        let latitude = LocationService.shared.rxLocation.value.latitude
        let longitude = LocationService.shared.rxLocation.value.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: defaultZoom)
        mapView = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
        mapView.styleMap()
        mapView.isMyLocationEnabled = true
        
        super.init(nibName: nil, bundle: nil)
        mapView.delegate = self
        
        
        centerOnUserLocation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
    }

    func updateMarkers() {
        markers.forEach({$0.map = nil})
        markers.removeAll()
        
        if let places = places {
            places.forEach { (place) in
                let marker = PlaceMarker(place: place)
                markers.insert(marker)
                marker.map = mapView
            }
        }
    }
    
    
    func setMapTopBottomPadding(top: CGFloat, bottom: CGFloat) {
        mapView.padding = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    }

}



extension MapViewController { /// Camera Manipulation
    
    func centerOnUserLocation(zoom: Float? = nil) {
        guard let latitude = mapView.myLocation?.coordinate.latitude,
            let longitude = mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom ?? defaultZoom)
        mapView.animate(to: camera)
    }
    
    func centerOnPlace(_ place: Place?, zoom: Float? = nil) {
        guard let place = place else {
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinates.latitude, longitude: place.coordinates.longitude, zoom: zoom ?? defaultZoom)
        mapView.animate(to: camera)
    }
    
    
    func centerOnList(_ list: ListModel) {
        var bounds = GMSCoordinateBounds()
        
        for placeItem in list.placeItems
        {
            bounds = bounds.includingCoordinate(placeItem.place.coordinates.asCLCoordinate2D)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: update)
    }
    
}


