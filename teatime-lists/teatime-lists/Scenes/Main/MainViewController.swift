//
//  MainViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/17/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation
import GoogleMaps

class MainViewController: UIViewController {
    
    enum MainState {
        case drawer
        case popover
        case search
    }
    
    var state: MainState = .drawer {
        didSet {
            if oldValue != state {
                updateUI(state)
            }
        }
    }
    
    
    let disposeBag = DisposeBag()
    let mainViewModel = MainViewModel()
    
    var mapViewController: MapViewController?
    var searchResultsViewController: SearchResultsViewController?
    var drawerViewController: DrawerViewController?
    var popoverViewController: PopoverViewController?
    
    var listBrowserViewController: ListBrowserViewController?
    var placeInfoViewController: PlaceInfoViewController?
    
    @IBOutlet var searchBarView: SearchBarView!
    @IBOutlet var floatingButton: FloatingButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = LocationService.shared

        searchBarView?.delegate = self
        addMapController()
        
        // TODO: BETTER
        listBrowserViewController = ListBrowserViewController(nibName: "ListBrowserViewController", bundle: nil)
        addDrawerController(with: listBrowserViewController!)
        
        placeInfoViewController = PlaceInfoViewController()
        addPopoverController(with: placeInfoViewController!)
        
        

        binding()
        
        view.bringSubview(toFront: floatingButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainViewModel.fetchLists()
    }
    
    
    private func binding() {
        mainViewModel.lists.asDriver().drive(onNext: { [weak self] (listModels) in
            self?.listBrowserViewController?.listsData = listModels ?? []
        }).disposed(by: disposeBag)
        
        
        mainViewModel.places.asDriver().drive(onNext: { [weak self] (places) in
            self?.mapViewController?.places = places
        }).disposed(by: disposeBag)
    }
    
    
    private func updateUI(_ state: MainState) {
        switch state {
        case .drawer:
            removeSearchResultsController()
            drawerViewController?.changeState(.partialScreen)
            popoverViewController?.changeState(.offScreen)
        case .popover:
            removeSearchResultsController()
            drawerViewController?.changeState(.offScreen)
            popoverViewController?.changeState(.onScreen)
        case .search:
            popoverViewController?.changeState(.offScreen)
            addSearchResultsController()
        }
    }
    
    
    @IBAction func addListTapped(_ sender: Any) {
        show(storyboard: .listEditing)
    }
}

