//
//  GraphService.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit



struct GraphService {

    func getFriends() {
        let parameters = ["fields": "name,picture.type(normal)"]
        
        FBSDKGraphRequest(graphPath: "me/friends", parameters: parameters).start { (connection, friends, error) in
            guard error == nil else {
                print(error)
                return
            }
            
//            var friends = [Friend]()
            
        }
    }
    
}
