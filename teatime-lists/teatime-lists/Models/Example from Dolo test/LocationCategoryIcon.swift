//
//  LocationCategoryIcon.swift
//  D-test
//
//  Created by Mathieu Perrais on 3/6/18.
//  Copyright © 2018 Mathieu Perrais. All rights reserved.
//

import Foundation

struct LocationCategoryIcon {
    let prefix: String
    let suffix: String
}


extension LocationCategoryIcon: Decodable {
    
    enum IconCodingKeys: String, CodingKey {
        case prefix = "prefix"
        case suffix = "suffix"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IconCodingKeys.self)
        
        prefix = try container.decode(String.self, forKey: .prefix)
        suffix = try container.decode(String.self, forKey: .suffix)
    }
}
