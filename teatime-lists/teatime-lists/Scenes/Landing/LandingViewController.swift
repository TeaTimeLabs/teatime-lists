//
//  LandingViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class LandingViewController: UIViewController {

    // -- Landing View Controller
    // The purpose of this screen is to extend the Splash screen to check if the user is authenticated
    // and display accordingly the Main screen or the Login screen
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FBSDKAccessToken.currentAccessTokenIsActive()) {
//            UIApplication.shared.keyWindow?.rootViewController =
        } else {
            UIApplication.shared.windows.last?.rootViewController = LoginViewController()
        }
        
    }


}
