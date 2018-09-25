//
//  LocationService.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/19/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class LocationService: NSObject {
    
    static var shared = LocationService()
    private let disposeBag = DisposeBag()
    
    var locationManager: CLLocationManager
    let rxLocation: Variable<CLLocationCoordinate2D> = Variable(defaultMapLocation)

    
    private override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        
        NotificationCenter.default.rx.notification(Notification.Name.UIApplicationDidBecomeActive).asObservable().subscribe(onNext: { [weak self] _ in
            self?.checkStatus()
        }).disposed(by: disposeBag)
        
        rxLocation.value = locationManager.location?.coordinate ?? defaultMapLocation
    }
    
    @discardableResult func checkStatus() -> Bool {
        if !CLLocationManager.locationServicesEnabled() {
            // Present Location services popup
            return false
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
            
        case .restricted, .denied:
//            presentLocationSettingsAlert()
            return false
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            return true
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        rxLocation.value = locations.last?.coordinate ?? defaultMapLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            rxLocation.value = manager.location?.coordinate ?? defaultMapLocation
        } else {
            rxLocation.value = defaultMapLocation
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: Handle Error
        rxLocation.value = defaultMapLocation
    }
}
