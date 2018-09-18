//
//  AuthenticationService.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase



enum FacebookPermissions {
    static let publicProfile = "public_profile"
    static let email = "email"
    static let friends = "user_friends"
}

struct AuthenticationService {

    static let shared = AuthenticationService()
    
    static let requestedPermissions = [FacebookPermissions.publicProfile,
                                       FacebookPermissions.email,
                                       FacebookPermissions.friends]
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    private init() {
        // Init and register the status listener and check the current Status of the user.
        // This is also triggered right away, we are relying on that method only to Navigate the User to Login or Main.
        authHandle = Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                UIWindow.topMostViewController()?.makeRootOfKeyWindow(storyboard: .main)
            } else {
                UIWindow.topMostViewController()?.makeRootOfKeyWindow(storyboard: .login)
            }
        }}
    
    
    func getUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func isAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    func landing() {
        // Aditional customization to do at launch if needed
    }
}

// Facebook
extension AuthenticationService {
    func handleFacebookLogin(result: FBSDKLoginManagerLoginResult?, error: Error?, completionHandler: ((Bool) -> ())?) {
        if let error = error {
            print(error.localizedDescription)
            completionHandler?(false)
            return
        }
        
        // Sending credentials to Firebase
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // TODO: Handle error
                print(error.localizedDescription)
                completionHandler?(false)
                return
            }
            
            completionHandler?(true)
        }
    }
    
    
    
}


// Firebase

