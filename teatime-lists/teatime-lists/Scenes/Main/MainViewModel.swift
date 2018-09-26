//
//  MainViewModel.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/23/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

final class MainViewModel {

    // INPUT
    var state: FilterState = .everyone
    var currentCoordinates: CLLocationCoordinate2D?
    let radiusInKMs: Double = 5.0
    
    
    // OUTPUT
    let lists = Variable<[ListModel]?>(nil)
    let places = Variable<Set<Place>?>(nil)
    
    
    
    // PUBLIC METHOD TO CALL
    func fetchLists() {
        fetchListsArgs(users: state.getUsers(), location: currentCoordinates?.toCLLocation, radiusInKilometers: radiusInKMs)
    }
    
    
    private func fetchListsArgs(users: [UserModel]? = nil, location: CLLocation? = nil, radiusInKilometers: Double? = nil) {
        ParseHelper.singleton.fetchUserLists(users: users, location: location, radiusInKilometers: radiusInKilometers) { (success, error, lists) in
            
            if let err = error {
                print("ERROR OCCURED WHILE RETRIEVING THE LISTS FOR THE CURRENT USER:", err)
                return
            }
            
            guard var lists = lists else { print("THE CURRENT USER HAS NO LIST"); return }
            lists.sort(by: {
                guard let date0 = $0.updatedAt, let date1 = $1.updatedAt else { return true }
                return date0 > date1
            })
            
            self.lists.value = lists
            
            var tmpPlaces = Set<Place>()
            lists.forEach({ (listModel) in
                listModel.placeItems.forEach({ (placeItem) in
                    tmpPlaces.insert(placeItem.place)
                })
            })
            
            self.places.value = tmpPlaces
        }
    }
    
    
    
}
