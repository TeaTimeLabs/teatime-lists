//
//  UIViewController+Presenter.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
//    func showPopup(viewController: UIViewController? = nil, title: String? = nil, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
//        /// Hide option popup if it was avaialbe in the screen before showing error popup
//        if CustomOptionDialogView.isVisible() {
//            CustomOptionDialogView.hideInView()
//        }
//        /// Dismissing the current alertviewcontroller if there is the one visible on the screen
//        if let presenting = self.presentingViewController as? UIAlertController {
//            presenting.dismiss(animated: false, completion: nil)
//        }
//        /// Determining error popup title
//        var ctitle: String? = title
//        if message == NetworkStatus.unknown.desc || message == ErrorMessage.common.desc {
//            ctitle = NetworkStatus.unknown.title
//        }
//        
//        let alertViewController = UIAlertController(title: ctitle ?? "", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: ButtonTitle.common.ok.title, style: .default, handler: handler)
//        alertViewController.addAction(okAction)
//        
//        if let rootViewController = viewController {
//            rootViewController.present(alertViewController, animated: true)
//        } else {
//            self.present(alertViewController, animated: true)
//        }
//    }
}
