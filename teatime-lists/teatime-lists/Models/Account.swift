//
//  Account.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/17/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import Foundation
//import Firebase


class Account {
    
    static var shared = Account()
    
    var friends: [Friend]? = nil
    
    private init() {}
    
    // Private
//    private func getFirebaseUser() -> User? {
//        return Auth.auth().currentUser
//    }
}


// MARK: - Basic properties
extension Account {
//    var isAuthenticate: Bool {
//        return getFirebaseUser() != nil
//    }
//    
//    var fullName: String? {
//        return getFirebaseUser()?.displayName
//    }
//    
//    var photoURL: URL? {
//        return getFirebaseUser()?.photoURL
//    }
}


// MARK: - Danger Zone
extension Account {

}

