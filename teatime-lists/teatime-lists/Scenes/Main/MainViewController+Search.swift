//
//  MainViewController+Search.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

extension MainViewController: SearchBarViewDelegate {
    func didBeginSearch() {
        state = .search
    }
    
    func didTapBackButton() {
        
        state = .drawer
    }
    
    func didTapCenterLocation() {
        mapViewController?.centerOnUserLocation()
    }
}


extension MainViewController: SearchResultsViewControllerDelegate {
    func didSelectPlace(_ place: Place?) {
        mapViewController?.centerOnPlace(place)
        
        state = .drawer
//        if let place = place {
//            placeInfoViewController?.changeContent(place: place)
//            state = .dra
//        }
    }
}


extension MainViewController {
    func addSearchResultsController() {
        // Safety
        removeSearchResultsController()
        
        searchResultsViewController = SearchResultsViewController(searchBar: searchBarView)
        add(searchResultsViewController!, inside: view)
        view.bringSubview(toFront: searchBarView)
        searchBarView.isActive = true
        
        searchResultsViewController?.delegate = self
    }
    
    func removeSearchResultsController() {
        searchBarView.isActive = false
        searchResultsViewController?.animateVisibility(visible: false) { [weak self] in 
            self?.searchResultsViewController?.removeFromParent()
            self?.searchResultsViewController = nil
        }
    }
}
