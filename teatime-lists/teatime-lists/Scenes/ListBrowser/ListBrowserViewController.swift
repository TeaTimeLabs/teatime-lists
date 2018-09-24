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
    
    @IBOutlet var tableView: UITableView!
    
    var listsData = [ListModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let attributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.styleThick.rawValue,
                                                         NSAttributedStringKey.foregroundColor : UIColor.primaryColor,
                                                         NSAttributedStringKey.font: UIFont.poppinsSemiBold(fontSize: 28)!]
        
        let underlineAttributedString = NSAttributedString(string: "LIST_BROWSER_FILTER_BUTTON_EVERYONE".localized, attributes: attributes)
        filterButton?.setAttributedTitle(underlineAttributedString, for: .normal)
        
        titleLabel?.text = " " + "LIST_BROWSER_FILTER_TITLE".localized
        titleLabel?.font = UIFont.poppinsSemiBold(fontSize: 28)
        titleLabel?.textColor = UIColor.darkTextColor
        
        registerTableViewCells()
        tableView.dataSource = self
        tableView.delegate = self
    }

  
}
