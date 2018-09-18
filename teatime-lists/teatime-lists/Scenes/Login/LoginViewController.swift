//
//  LoginViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        view.addSubview(loginButton)
        
        loginButton.center = view.center
    }
    
}



extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        AuthenticationService.shared.handleFacebookLogin(result: result, error: error) { [weak self] success in
            if success {
                self?.makeRootOfKeyWindow(storyboard: .main)
            } else {
                // display warning message to try again
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
}
