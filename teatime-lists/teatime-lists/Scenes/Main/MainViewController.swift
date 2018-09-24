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

    let disposeBag = DisposeBag()
    let mainViewModel = MainViewModel()
    
    var mapViewController: MapViewController?
    var drawerViewController: DrawerViewController?
    var popoverViewController: PopoverViewController?
    
    var listBrowserViewController: ListBrowserViewController?
    
    @IBOutlet var searchBarView: SearchBarView!
    @IBOutlet var floatingButton: FloatingButton!
    
    enum MainState {
        case popover
        case drawer
        case search
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = LocationService.shared

        searchBarView?.delegate = self
        addMapController()
        
        listBrowserViewController = ListBrowserViewController(nibName: "ListBrowserViewController", bundle: nil)
        addDrawerController(with: listBrowserViewController!)
        
        addPopoverController(with: PlaceInfoViewController())
        
        
        mainViewModel.lists.asDriver().drive(onNext: { [weak self] (listModels) in
            self?.listBrowserViewController?.listsData = listModels ?? []
        }).disposed(by: disposeBag)
        
        
        mainViewModel.places.asDriver().drive(onNext: { [weak self] (places) in
            self?.mapViewController?.places = places
        }).disposed(by: disposeBag)
        
        
        view.bringSubview(toFront: floatingButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainViewModel.fetchLists()
    }
    
    
    @IBAction func addListTapped(_ sender: Any) {
        show(storyboard: .listEditing)
    }
    
    
}

