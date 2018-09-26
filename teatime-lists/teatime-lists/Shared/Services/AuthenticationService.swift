//
//  AuthenticationService.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import Parse



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
    
    
    private init() { }
    
    
    func getUser() -> UserModel? {
        return PFUser.current() as? UserModel
    }
    
    func isAuthenticated() -> Bool {
        return PFUser.current() != nil
    }
    
    
    func loginWithFacebook() {
        PFFacebookUtils.logInInBackground(withReadPermissions: AuthenticationService.requestedPermissions) { (user, error) in
            guard let user = user else {
                print("User cancelled the login")
                return
            }
            
            GraphService.updateUserInfo()
            
            if user.isNew {
                print("User is new")
                UIWindow.topMostViewController()?.makeRootOfKeyWindow(storyboard: .main)
            } else {
                print("user is coming back")
                UIWindow.topMostViewController()?.makeRootOfKeyWindow(storyboard: .main)
            }

        }
        
    }
    
    
    func landing() {
        if let user = PFUser.current(), PFFacebookUtils.isLinked(with: user) {
            UIWindow.topMostViewController()?.makeRootOfKeyWindow(storyboard: .main)
            GraphService.updateUserInfo()
            return
        }
        UIWindow.topMostViewController()?.makeRootOfKeyWindow(storyboard: .login)
    }
}

