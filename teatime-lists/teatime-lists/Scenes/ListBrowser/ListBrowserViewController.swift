//
//  ListBrowserViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/19/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import TinyConstraints

class ListBrowserViewController: UIViewController {

    private let titleContainerView: UIView
    private let filterButton: UIButton
    private let titleLabel: UILabel
    
    private let tableView: UITableView
    
    init() {
        tableView = UITableView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        filterButton = UIButton(frame: .zero)
        titleContainerView = UIView()
            
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}
