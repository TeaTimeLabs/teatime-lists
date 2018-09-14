//
//  LocationResults.swift
//  D-test
//
//  Created by Mathieu Perrais on 3/5/18.
//  Copyright © 2018 Mathieu Perrais. All rights reserved.
//

import Foundation

struct LocationResults {
    let locations: [Location]
}

extension LocationResults: Decodable {
    
    enum ResponseBlockCodingKeys: String, CodingKey {
        case response = "response"
    }
    
    private enum LocationResultsCodingKeys: String, CodingKey {
        case locations = "venues"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: ResponseBlockCodingKeys.self)
        let result = try container.nestedContainer(keyedBy: LocationResultsCodingKeys.self, forKey: .response)
        
        locations = try result.decode([Location].self, forKey: .locations)
    }
}
