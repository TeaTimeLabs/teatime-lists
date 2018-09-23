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
    
    func addPopoverController(with content: UIViewController, state: PopoverState = .offScreen) {
        guard let popoverController = popoverViewController else {
            popoverViewController = PopoverViewController(content: content)
            add(popoverViewController!, inside: view, pin: false)
            popoverViewController?.setUpConstraints()
            
            return
        }
        
        popoverController.changeContent(content)
    }
}

