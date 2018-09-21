//
//  ListDetailsViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

final class ListDetailsViewController: UIViewController {

//    let list: List
    let tableView: UITableView
    
    init() {
//        list = list
        tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        view.addSubviewAndPin(tableView)

        // Do any additional setup after loading the view.
    }

    

}
