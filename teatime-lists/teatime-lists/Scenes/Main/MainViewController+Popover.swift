//
//  MainViewController+Popover.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import TinyConstraints


extension MainViewController {
    
    func addPopoverController(with content: UIViewController) {
        guard let popoverController = popoverViewController else {
            popoverViewController = PopoverViewController(content: content)
//            popoverViewController?.delegate = self
            add(popoverViewController!, inside: view, pin: false)
        
            let margins = TinyEdgeInsets(top: 0, left: 8.0, bottom: 8.0, right: -8.0)
            popoverViewController?.view.edgesToSuperview(excluding: .top,
                                                         insets: margins)
            
            return
        }
        
        popoverController.changeContent(content)
    }
}

