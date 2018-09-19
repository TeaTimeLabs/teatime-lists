//
//  GraphService.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import FBSDKCoreKit



struct GraphService {

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
