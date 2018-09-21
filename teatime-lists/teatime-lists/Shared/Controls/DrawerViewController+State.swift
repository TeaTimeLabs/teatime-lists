//
//  DrawerViewController+State.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit


enum DrawerState {
    case fullScreen
    case partialScreen
    case minimumScreen
    case offScreen
    
    // Init for Pan Gesture to determine which is the state desired by the Users
    init?(positionY: CGFloat, velocityY: CGFloat) {
        let array = [DrawerState.fullScreen, DrawerState.partialScreen, DrawerState.minimumScreen] // DrawerState.offScreen (not for dragging)
        
        // We get the Closest State from the Y position
        if let closest = array.enumerated().min( by: { abs($0.1.getYPosition() - positionY) < abs($1.1.getYPosition() - positionY) } ) {
            
            let diffWithClosest = (closest.element.getYPosition() - positionY)
            if ((diffWithClosest >= 0) && (velocityY > 0)) || ((diffWithClosest <= 0) && (velocityY < 0) || abs(velocityY) < 200)  {
                self = closest.element // Return the Closest if the touch is towards it or negligeable
            } else {
                // if not return the next or previous one depending on the direction
                self = ((diffWithClosest > 0) ? array.item(before: closest.element) : array.item(after: closest.element)) ?? closest.element
            }
        } else {
            return nil
        }
    }
    
    
    func getYPosition() -> CGFloat {
        switch self {
        case .fullScreen:
            return 0.0
        case .partialScreen:
            return UIScreen.main.bounds.height * 0.60
        case .minimumScreen:
            return UIScreen.main.bounds.height - 70
        case .offScreen:
            return UIScreen.main.bounds.height
        }
    }
    
    func getHeight() -> CGFloat {
        return UIScreen.main.bounds.height - self.getYPosition()
    }
}
