//
//  Account.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/17/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import Foundation
import RxSwift


struct Account {
    
    enum Status {
        case authenticated
        case guest
    }
    
    
    static var shared = Account()
    
    
    var status: Status = .guest
    
    
    private init() {}
}
