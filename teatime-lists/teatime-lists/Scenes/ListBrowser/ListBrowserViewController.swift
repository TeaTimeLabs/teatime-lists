//
//  ListBrowserViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit


protocol ListBrowserViewControllerDelegate: class {
    func didChangeFilter(_ filter: FilterState)
    func didSelectList(_ list: ListModel)
    
    func didTapNewList()
    func didTapOnLowBar()
}



final class ListBrowserViewController: UIViewController {
    
    weak var delegate: ListBrowserViewControllerDelegate?
    
    
    private var state: FilterState = .everyone {
        didSet {
            filterButton?.setAttributedTitle(state.getButtonTitle(), for: .normal)
            delegate?.didChangeFilter(state)
        }
    }
    
    @IBOutlet var headerBarView: UIView?
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

        filterButton?.setAttributedTitle(state.getButtonTitle(), for: .normal)
        
        titleLabel?.text = " " + "LIST_BROWSER_FILTER_TITLE".localized
        titleLabel?.font = UIFont.poppinsSemiBold(fontSize: 28)
        titleLabel?.textColor = UIColor.darkTextColor
        
        registerTableViewCells()
        tableView.dataSource = self
        tableView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerBarTapped(_:)))
        headerBarView?.addGestureRecognizer(tap)
    }

    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let everyoneAction: ActionSheetAction =  { [weak self] action in
            self?.state = .everyone
        }
        
        let onlyMeAction: ActionSheetAction =  { [weak self] action in
            self?.state = .onlymy
        }
        
        let friendsAction: ActionSheetAction =  { [weak self] action in
            self?.state = .friends
        }
        
        showActionSheet(firstTitle: "LIST_BROWSER_FILTER_BUTTON_EVERYONE".localized, secondTitle: "LIST_BROWSER_FILTER_BUTTON_ONLY_MINE".localized, thirdTitle: "LIST_BROWSER_FILTER_BUTTON_FRIENDS".localized, everyoneAction, onlyMeAction, friendsAction)
    }
    
    @objc func headerBarTapped(_ sender: Any) {
        delegate?.didTapOnLowBar()
    }
    
    @IBAction func newListTapped(_ sender: Any) {
        delegate?.didTapNewList()
    }
    
}
