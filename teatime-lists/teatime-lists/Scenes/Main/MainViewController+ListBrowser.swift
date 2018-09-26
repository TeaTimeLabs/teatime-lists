//
//  MainViewController+ListBrowser.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/26/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

extension MainViewController: ListBrowserViewControllerDelegate {
    func didChangeFilter(_ filter: FilterState) {
        mainViewModel.state = filter
        mainViewModel.fetchLists()
    }
    
    func didSelectList(_ list: ListModel) {
        mapViewController?.centerOnList(list)
    }
    
    
}
