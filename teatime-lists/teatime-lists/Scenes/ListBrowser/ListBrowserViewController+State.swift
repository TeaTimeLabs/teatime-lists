//
//  ListBrowserViewController+State.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/26/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

enum FilterState {
    case everyone
    case onlymy
    case friends
    
    func getUsers() -> [UserModel]? {
        switch self {
        case .onlymy:
            if let user = AuthenticationService.shared.getUser() {
                return [user]
            }
            return nil
        default:
            return nil
        }
    }
    
    func getButtonTitle() -> NSAttributedString {
        
        var title = "LIST_BROWSER_FILTER_BUTTON_EVERYONE".localized
        
        switch self {
        case .everyone:
            title = "LIST_BROWSER_FILTER_BUTTON_EVERYONE".localized
        case .onlymy:
            title = "LIST_BROWSER_FILTER_BUTTON_ONLY_MY".localized
        case .friends:
            title = "LIST_BROWSER_FILTER_BUTTON_FRIENDS".localized
        }
        
        
        let attributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.styleThick.rawValue,
                                                         NSAttributedStringKey.foregroundColor : UIColor.primaryColor,
                                                         NSAttributedStringKey.font: UIFont.poppinsSemiBold(fontSize: 28)!]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
}
