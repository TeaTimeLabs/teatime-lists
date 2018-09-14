//
//  Location.swift
//  D-test
//
//  Created by Mathieu Perrais on 3/5/18.
//  Copyright © 2018 Mathieu Perrais. All rights reserved.
//

import Foundation

struct Location {
    let id: String
    let name: String
    let address: String?
    let crossStreet: String?
    let distance: Int
    let categories: [LocationCategory]?
}


extension Location: Decodable {
    enum LocationCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case addressBlock = "location"
        case categories = "categories"
    }
    
    enum AddressBlockCodingKeys: String, CodingKey {
        case address = "address"
        case crossStreet = "crossStreet"
        case distance = "distance"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationCodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let locationNested = try container.nestedContainer(keyedBy: AddressBlockCodingKeys.self, forKey: .addressBlock)
        address = try locationNested.decodeIfPresent(String.self, forKey: .address)
        crossStreet = try locationNested.decodeIfPresent(String.self, forKey: .crossStreet)
        distance = try locationNested.decode(Int.self, forKey: .distance)
        
        categories = try container.decodeIfPresent([LocationCategory].self, forKey: .categories)
    }
}
