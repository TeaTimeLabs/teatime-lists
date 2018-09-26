//
//  SearchResultsViewModel.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/25/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import RxSwift

class SearchResultsViewModel {

    let searchQuery: Observable<String>
    let dataSource: Variable<[Place]>
    
    
    private let disposeBag = DisposeBag()
    
    init(search: Observable<String>) {
        self.searchQuery = search
        self.dataSource = Variable<[Place]>([])
        
        self.searchQuery
            .throttle(0.5, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] (query) in
                if query == "" {
                    self?.fetchGoogleNearbyPlaces()
                } else {
                    self?.fetchGoogleSearchPredictions(userQuery: query)
                }
            }).disposed(by: disposeBag)
    }
    
    func getPlace(for indexPath: IndexPath) -> Place? {
        return dataSource.value[safe: indexPath.row]
    }
    
    
    
    //// BEN's CODE
    //// ==========
    
    func fetchGoogleNearbyPlaces(){
        //Updating the list of nearby places
        GoogleHelper.singleton.fetchNearbyPlacesList { [weak self] (error, googlePlaces) in
            if let error = error{
                print("ERROR OCCURED WHILE FETCHING THE NEARBY PLACES: ", error)
                return
            }
            self?.dataSource.value = googlePlaces ?? []
        }
    }
    
    func fetchGoogleSearchPredictions(userQuery: String){
        GoogleHelper.singleton.getPlaceAutoCompletePredictions(userQuery: userQuery, queryID: 0) { [weak self] (queryID, error, googlePlaces) in
            if let error = error{
                print("ERROR OCCURED WHILE RETRIEVING GOOGLE PLACE PREDICTIONS: ", error)
                return
            }
            self?.dataSource.value = googlePlaces ?? []
        }
    }
    
}
