//
//  PopoverViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

final class PopoverViewController: UIViewController {

    private var contentViewController: UIViewController
    
    private var hiddingConstraint: NSLayoutConstraint?
    
    
    init(content: UIViewController) {
        contentViewController = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 4.0
        view.layer.shadowRadius = 2.5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.20
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        contentViewController.view.layer.cornerRadius = 4.0
        contentViewController.view.clipsToBounds = true
        changeContent(contentViewController)
    }
    
    func setUpConstraints() {
        view.rightToSuperview(offset: 8)
        view.leftToSuperview(offset: 8)
        view.bottomToSuperview(offset: -8, priority: .defaultHigh, usingSafeArea: true)
        if let superview = view.superview {
            hiddingConstraint = view.topToBottom(of: superview, offset: 30)
        }
    }
    
    func changeContent(_ content: UIViewController) {
        contentViewController.removeFromParent()
        contentViewController = content
        add(contentViewController, inside: view, pin: true)
    }
    
    
    func changeState(_ state: PopoverState, animated: Bool = true, duration: TimeInterval = 5.0) {
        

        
        UIView.animate(withDuration: duration, delay: 0.0,
                       options: [], animations: {
                        
                        switch state {
                        case .offScreen:
                            self.hiddingConstraint?.isActive = true
                        default:
                            self.hiddingConstraint?.isActive = false
                        }
                        self.view.layoutIfNeeded()
        })
    }

}
