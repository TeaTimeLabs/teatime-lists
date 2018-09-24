//
//  PlaceListItem.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/20/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

import Foundation
import Parse

class PlaceItem : PFObject, PFSubclassing{
    @NSManaged var place : Place
    @NSManaged var position : Int
 
    override init(){
        super.init()
    }
    
    
    init(list: ListModel, place: Place, position: Int = 0){
        super.init()
        self.place = place
        self.position = position
    }
    
    
    static func parseClassName() -> String {
        return "PlaceItem"
    }

}
