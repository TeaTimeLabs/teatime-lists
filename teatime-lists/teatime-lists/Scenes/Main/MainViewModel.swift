//
//  MainViewModel.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/23/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct MainViewModel {

    let lists = Variable<[ListModel]?>(nil)
    let places = Variable<Set<Place>?>(nil)
    
    
    func fetchLists() {
        ParseHelper.singleton.fetchUserLists(users: nil) { (success, error, lists) in
            
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
