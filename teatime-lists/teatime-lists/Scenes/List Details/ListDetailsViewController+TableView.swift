//
//  ListDetailsViewController+TableView.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

extension ListDetailsViewController {
    func registerTableViewCells() {
        tableView.register(cellType:ListInfoTableViewCell.self)
        tableView.register(cellType:ListDescriptionTableViewCell.self)
        tableView.register(cellType:PlaceInfoTableViewCell.self)
    }
}


extension ListDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
}
