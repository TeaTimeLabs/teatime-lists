//
//  Routes.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

extension UIViewController: Routable {
    public enum StoryboardIdentifier: String {
        case login = "Login"
        case main = "Main"
        case listEditing = "ListEditing"
    }
}


