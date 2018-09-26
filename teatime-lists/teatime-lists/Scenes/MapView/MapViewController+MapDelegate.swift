//
//  MapViewController+MapDelegate.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/25/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import GoogleMaps

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // Unselect current Market
        if let previousSelectedMarker = mapView.selectedMarker as? PlaceMarker {
            previousSelectedMarker.isSelected = false
        }
        
        // Select Tapped Marker and send it back to the Main for info display
        if let selectedMarker = marker as? PlaceMarker {
            selectedMarker.isSelected = true
            delegate?.didSelectMarker(place: selectedMarker.place)
        }
        
        mapView.selectedMarker = marker
        
        // tap event handled by delegate
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        markers.forEach({ $0.isSelected = false})
        
        mapView.selectedMarker = nil // should be already nil but heh.
        delegate?.didSelectMarker(place: nil)
    }
}
