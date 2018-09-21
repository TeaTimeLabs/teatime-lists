//
//  MainViewController+Drawer.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit


extension MainViewController {
    
    func addDrawerController(with content: UIViewController) {
        guard let drawerContainer = drawerViewController else {
            drawerViewController = DrawerViewController(content: content)
            drawerViewController?.delegate = self
            add(drawerViewController!, inside: view, pin: false)
            drawerViewController?.changeState(.partialScreen, animated: false)
            return
        }
        
        drawerContainer.changeContent(content)
    }
}




extension MainViewController: DrawerViewControllerDelegate {
    func didUpdateFrame(_ frame: CGRect) {
        // Pushing up the Map according to the Drawer Height
        mapViewController?.setMapBottomPadding(frame.height)
        
        searchBarView?.alpha = (frame.minY - 150) / 180
    }
}
