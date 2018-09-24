//
//  GraphService.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Parse
import FBSDKCoreKit

struct GraphService {

    static func updateUserInfo() {
        
        guard FBSDKAccessToken.current() != nil else {
            return
        }
        
        let parameters = ["fields": "id, email, first_name, last_name, name, picture.type(normal)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            guard error == nil, let result = result else {
                print(error)
                return
            }
            
            let json = JSON(result)
            
            print(json)
            let user = PFUser.current() as? UserModel
            user?.email = json["email"].stringValue
            user?.lastname = json["last_name"].stringValue
            user?.firstname = json["first_name"].stringValue
            user?.facebookID = json["id"].stringValue
            user?.fullname = json["name"].stringValue
            user?.photoURL = json["picture"]["data"]["url"].stringValue
            
            user?.saveInBackground()
        }
    }
    
    
    func getFriends() -> [Friend]? {
        // Only if current Facebook authentication is good
//        guard FBSDKAccessToken.current() != nil else {
//            return nil
//        }
//
//        let parameters = ["fields": "name,picture.type(normal)"]
//
//        FBSDKGraphRequest(graphPath: "me/friends", parameters: parameters).start { (connection, result, error) in
//            guard error == nil else {
//                print(error)
//                return
//            }
//
//            guard let result = result else {
//                // Parsining error
//                return
//            }
//
//            ///////// SUPER TERRIBLE CODE, REDO A PROPER WAY
//            let json = JSON(result)
//            let friends = try? JSONDecoder().decode([Friend].self, from: json["data"].rawData())
//
//        }
        
        return nil
    }
    
}
