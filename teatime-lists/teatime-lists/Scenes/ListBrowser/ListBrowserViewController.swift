//
//  ListBrowserViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

class ListBrowserViewController: UIViewController {
    
    @IBOutlet var filterButton: UIButton?
    @IBOutlet var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let attributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.styleThick.rawValue,
                                                         NSAttributedStringKey.foregroundColor : UIColor.primaryColor!,
                                                         NSAttributedStringKey.font: UIFont.poppinsSemiBold(fontSize: 28)!]
        
        let underlineAttributedString = NSAttributedString(string: "Everyone’s", attributes: attributes)
        filterButton?.setAttributedTitle(underlineAttributedString, for: .normal)
        
        titleLabel?.text = " lists"
        titleLabel?.font = UIFont.poppinsSemiBold(fontSize: 28)
        titleLabel?.textColor = UIColor.darkTextColor
    }


    
}
