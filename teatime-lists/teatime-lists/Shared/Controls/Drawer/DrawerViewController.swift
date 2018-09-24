//
//  DrawerViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/20/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import TinyConstraints

protocol DrawerViewControllerDelegate: class {
    func didUpdateFrame(_ frame: CGRect)
}


class DrawerViewController: UIViewController {

    weak var delegate: DrawerViewControllerDelegate?
    private var contentViewController: UIViewController
    
    
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
        add(contentViewController, inside: view, pin: true)
//        contentViewController.view.edgesToSuperview(insets: UIApplication.shared.keyWindow!.safeAreaInsets)
    }
    
    
    func changeState(_ state: DrawerState, animated: Bool = true, duration: TimeInterval = 0.8) {
        let finalDuration = animated ? duration : 0.0 // 0.0 animation if not animated
        
        UIView.animate(withDuration: finalDuration, delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.1, options: [.allowUserInteraction, .layoutSubviews], animations: {
            // configure the State from Enum values
            self.view.frame = CGRect(x: 0, y: state.getYPosition(), width: self.view.frame.width, height: state.getHeight())
            self.delegate?.didUpdateFrame(self.view.frame)
        })
    }
    

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        // minY + translation.y  (but bounded to 0 and Screen height)
        let y = max(min(view.frame.minY + translation.y, UIScreen.main.bounds.height), 0.0)
        
        view.frame = CGRect(x: 0, y: y, width: view.frame.width, height:  UIScreen.main.bounds.height - y)
        delegate?.didUpdateFrame(view.frame)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            
            if let targetState = DrawerState.init(positionY: y, velocityY: velocity.y) {
                var duration =  abs(Double((targetState.getYPosition() - y) / velocity.y))
                duration = duration > 0.5 ? 0.5 : duration
                changeState(targetState, animated: true, duration: duration)
            }
        }
    }
}
