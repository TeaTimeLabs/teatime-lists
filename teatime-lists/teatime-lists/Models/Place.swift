//
//  Place.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/15/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

import Foundation
import Parse

class Place: PFObject, PFSubclassing{
 
    @NSManaged var googleID: String
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var shortAddress: String
    @NSManaged var formattedAddress: String
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var lat : Double
    @NSManaged var long: Double
    @NSManaged var imageURL: String
    @NSManaged var followers: [UserModel]
    
    
    override init(){
        super.init()
    }
    
    init(googleID: String, name: String, category: String, formattedAddress: String = "", shortAddress: String = "", city: String = "", country: String = "", lat: Double, long: Double, imageURL: String = ""){
        super.init()
        self.googleID = googleID
        self.name = name
        self.category = category
        self.formattedAddress = formattedAddress
        self.shortAddress = shortAddress
        self.city = city
        self.country = country
        self.lat = lat
        self.long = long
        self.imageURL = imageURL
        self.followers = [UserModel]()
    }
    
    static func parseClassName() -> String {
        return "Place"
    }
    
    var categoryIcon: UIImage {
        let iconName = String.underscoreToDash(text: category)
        if let iconImage = UIImage(named: iconName){
            return iconImage
        } else{
            return #imageLiteral(resourceName: "default-category")
        }
    }
    
}
