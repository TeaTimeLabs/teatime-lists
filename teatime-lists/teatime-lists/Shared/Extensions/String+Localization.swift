//
//  String+Localization.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedWithParameters(values: CVarArg...) -> String {
        return String(format: localized, arguments: values)
    }
}
