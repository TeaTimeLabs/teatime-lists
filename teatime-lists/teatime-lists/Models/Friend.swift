//
//  Friend.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/17/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import Foundation

struct Friend {
    let id: String
    let name: String
    let pictureURL: String?
}


extension Friend: Decodable {
    enum FriendCodingKey: String, CodingKey {
        case id = "id"
        case name = "name"
        case picture = "picture"
    }

    enum PictureCodingKey: String, CodingKey {
        case data = "data"
    }
    
    enum PictureDataCodingKey: String, CodingKey {
        case url = "url"
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FriendCodingKey.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let pictureNested = try container.nestedContainer(keyedBy: PictureCodingKey.self, forKey: .picture)
        let pictureDataNested = try pictureNested.nestedContainer(keyedBy: PictureDataCodingKey.self, forKey: .data)
        
        pictureURL = try pictureDataNested.decodeIfPresent(String.self, forKey: .url)
    }
}

