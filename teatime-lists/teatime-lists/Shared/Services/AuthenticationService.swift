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


enum UserStatus {
    case authenticated
    case guest
}


struct AuthenticationService {

    static let shared = AuthenticationService()
    
    static let requestedPermissions = [FacebookPermissions.publicProfile,
                                       FacebookPermissions.email,
                                       FacebookPermissions.friends]
    
    private init() {}
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
                // ...
                completionHandler?(false)
                return
            }
            
            completionHandler?(true)

            
//            GraphService().getFriends()
        }
    }
    
    
    
}


// Firebase

