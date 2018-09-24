//
//  ListModel.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/12/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

import Foundation
import Parse

final class ListModel: PFObject, PFSubclassing {
    @NSManaged var user : UserModel
    @NSManaged var title : String
    @NSManaged var listDescription : String
    @NSManaged var imageURL : String
    @NSManaged var placeItems : [PlaceItem]
    
    var image : UIImage?
    var uniqueCities : [String] {
        return placeItems.reduce([], { $0.contains($1.place.city) ? $0 : $0 + [$1.place.city] })
    }
    var isOwner: Bool {
        return user.objectId == ParseHelper.currentUser?.objectId
    }
    
    override init(){
        super.init()
    }
    
    
    init(user: UserModel, title: String, listDescription: String = "", image: UIImage? = nil, imageURL: String = "", placeItems: [PlaceItem]? = nil){
        super.init()
        self.title = title
        self.listDescription = listDescription
        self.image = image
        self.imageURL = imageURL
        if let items = placeItems{
           self.placeItems = items
        }
    }
    
    func placeItemsDidSet(){
        guard !placeItems.isEmpty else { return }
        placeItems.sort { $0.position < $1.position }
    }
    
    
    static func parseClassName() -> String {
        return "List"
    }
    
    
}
