//
//  PopoverViewController+State.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit


enum PopoverState {
    case onScreen
    case offScreen
    
    
    func getFrame() -> CGRect {
        return CGRect(x: getMargins().left, y: getYPosition(), width: getWidth(), height: getHeight())
    }
    
    
    private func getMargins() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
    }
    
    private func getYPosition() -> CGFloat {
        switch self {
        case .onScreen:
            return UIScreen.main.bounds.height - (getHeight() + getMargins().bottom + UIWindow.safeAreaBottom)
        case .offScreen:
            return UIScreen.main.bounds.height
        }
    }
    
    private func getHeight() -> CGFloat {
        return getWidth() * 0.85
    }
    
    private func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width - (getMargins().left + getMargins().right)
    }
}
