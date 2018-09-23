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
    
    var mapViewController: MapViewController?
    var drawerViewController: DrawerViewController?
    var popoverViewController: PopoverViewController?
    
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
        // TODO: make a static method on it to instantiate
        addDrawerController(with: ListBrowserViewController(nibName: "ListBrowserViewController", bundle: nil))
        
        addPopoverController(with: PlaceInfoViewController())
        
        view.bringSubview(toFront: floatingButton)
        
        mapViewController?.selectedMarker.asDriver().drive(onNext: { [weak self] (marker) in
            self?.popoverViewController?.changeState((marker != nil) ? .onScreen : .offScreen)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func addListTapped(_ sender: Any) {
        present(storyboard: .listEditing)
    }
    
    
}

