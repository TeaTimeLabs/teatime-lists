//
//  SearchResultsViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/25/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

protocol SearchResultsViewControllerDelegate: class {
    func didSelectPlace(_ place: Place?)
}


final class SearchResultsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: SearchResultsViewModel
    private let tableView = UITableView()
    
    private weak var searchBar: SearchBarView?
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    init(searchBar: SearchBarView) {
        viewModel = SearchResultsViewModel(search: searchBar.searchQuery)
        self.searchBar = searchBar
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.white
        view.alpha = 0.0
        
        tableView.separatorStyle = .none
        tableView.register(cellType: PlaceResultTableViewCell.self)
        
        view.addSubview(tableView)
        tableView.edgesToSuperview(insets: TinyEdgeInsets(top: 75, left: 23, bottom: -10, right: -23), usingSafeArea: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        viewModel.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "PlaceResultTableViewCell",
                       cellType: PlaceResultTableViewCell.self)) {
                        row, place, cell in
                        cell.place = place
            }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateVisibility(visible: true)
    }


    func animateVisibility(visible: Bool, completionHandler: (()->())? = nil) {        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = visible ? 1.0 : 0.0
        }) { (_) in
            completionHandler?()
        }
    }
}


extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar?.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        searchBar?.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = viewModel.getPlace(for: indexPath)
        
        searchBar?.forceSearchQuery(place?.name)
        delegate?.didSelectPlace(place)
    }

}
