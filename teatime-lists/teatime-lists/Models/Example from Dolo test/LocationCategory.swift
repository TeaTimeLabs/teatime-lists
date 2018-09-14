//
//  LocationCategory.swift
//  D-test
//
//  Created by Mathieu Perrais on 3/6/18.
//  Copyright © 2018 Mathieu Perrais. All rights reserved.
//

import Foundation

struct LocationCategory {
    let primary: Bool
    let icon: LocationCategoryIcon
}

extension LocationCategory: Decodable {
    
    enum CategoryCodingKeys: String, CodingKey {
        case primary = "primary"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CategoryCodingKeys.self)
        
        primary = try container.decode(Bool.self, forKey: .primary)
        icon = try container.decode(LocationCategoryIcon.self, forKey: .icon)
    }
}
