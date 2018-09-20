//
//  DrawerViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DrawerViewControllerDelegate: class {
    func didUpdateFrame(_ frame: CGRect)
}


class DrawerViewController: UIViewController {

    weak var delegate: DrawerViewControllerDelegate?
    private var contentViewController: UIViewController
    
    let fullView: CGFloat = 0
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 400
    }
    
    init(content: UIViewController) {
        contentViewController = content
        super.init(nibName: nil, bundle: nil)
        
        view.isOpaque = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should never happen")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.shadowRadius = 2.5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.20
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        
        changeContent(contentViewController)
       
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    
    func changeContent(_ content: UIViewController) {
        contentViewController.removeFromParent()
        contentViewController = content
        add(contentViewController, inside: view)
    }
    
    

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height:  UIScreen.main.bounds.height - (y + translation.y))
        delegate?.didUpdateFrame(self.view.frame)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 0.8 ? 0.8 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: 400)
                    self.delegate?.didUpdateFrame(self.view.frame)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: UIScreen.main.bounds.height)
                    self.delegate?.didUpdateFrame(self.view.frame)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    // If Partial View
                }
            })
        }
    }
}
