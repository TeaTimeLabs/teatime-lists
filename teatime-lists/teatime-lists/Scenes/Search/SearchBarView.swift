//
//  SearchBarView.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/19/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import RxSwift
import TinyConstraints

protocol SearchBarViewDelegate: class {
    func didTapCenterLocation()
    func didBeginSearch()
    func didTapBackButton()
}

class SearchBarView: UIView {
    
    weak var delegate: SearchBarViewDelegate?
    let searchQuery = BehaviorSubject<String>(value: "")

    // Private
    private let leftIconImageView = UIImageView()
    private let searchTextField = UITextField()
    private let nearbyButton = UIButton(type: UIButtonType.custom)
    private let backButton = UIButton(type: UIButtonType.custom)
    
    var isActive = false {
        didSet {
            backButton.isHidden = !isActive
            leftIconImageView.isHidden = isActive
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.shadowRadius = 2.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.24
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        addSubview(backButton)
        addSubview(leftIconImageView)
        addSubview(searchTextField)
        addSubview(nearbyButton)
        
        leftIconImageView.edgesToSuperview(excluding: .trailing)
        nearbyButton.edgesToSuperview(excluding: .leading)
        nearbyButton.width(50.0)
        searchTextField.topToSuperview()
        searchTextField.bottomToSuperview()
        leftIconImageView.rightToLeft(of: searchTextField)
        leftIconImageView.width(50.0)
        searchTextField.rightToLeft(of: nearbyButton)
        
        searchTextField.setHugging(.defaultLow, for: .horizontal)
        searchTextField.placeholder = "Nearby"
        searchTextField.textColor = UIColor.darkTextColor
        searchTextField.font = UIFont.poppinsRegular()
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(SearchBarView.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        searchTextField.autocorrectionType = .no
        
        leftIconImageView.image = #imageLiteral(resourceName: "icnSearch")
        leftIconImageView.contentMode = .center
        
        nearbyButton.setImage(#imageLiteral(resourceName: "icnLocate"), for: .normal)
        nearbyButton.addTarget(self, action: #selector(didTapCenterLocation), for: .touchUpInside)
        
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor.darkTextColor, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.edgesToSuperview(excluding: .trailing)
        backButton.width(50.0)
        backButton.isHidden = true
    }
    
    
    func forceSearchQuery(_ query: String?) {
        searchTextField.text = query
        textFieldDidChange(searchTextField)
    }
    
    @objc func didTapCenterLocation() {
        delegate?.didTapCenterLocation()
    }
    
    @objc func didTapBackButton() {
        endEditing(true)
        isActive = false
        delegate?.didTapBackButton()
    }
    
    @objc func didTapSearch() {
        forceSearchQuery(nil)
        delegate?.didBeginSearch()
    }
}



extension SearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isActive {
            didTapSearch()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchString = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        searchQuery.onNext(searchString)
    }
}
