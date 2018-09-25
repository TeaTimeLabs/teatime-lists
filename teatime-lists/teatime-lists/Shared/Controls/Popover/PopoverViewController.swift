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
    
    
    func changeContent(_ content: UIViewController) {
        contentViewController.removeFromParent()
        contentViewController = content
        add(contentViewController, inside: view, pin: true)
    }
    
    
    func changeState(_ state: PopoverState, animated: Bool = true, duration: TimeInterval = 0.3) {
        let finalDuration = animated ? duration : 0.0 // 0.0 animation if not animated
        
        UIView.animate(withDuration: finalDuration, delay: 0.0,
                       options: [.layoutSubviews], animations: {
                        // configure the State from Enum values
                        self.view.frame = state.getFrame()
                        
                        //self.delegate?.didUpdateFrame(self.view.frame)
        })
    }

}
