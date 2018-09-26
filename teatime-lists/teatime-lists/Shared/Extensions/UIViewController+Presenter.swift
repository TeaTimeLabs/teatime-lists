//
//  UIViewController+Presenter.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/14/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

typealias ActionSheetAction = (UIAlertAction) -> Void

extension UIViewController {
    
    func alertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showActionSheet(firstTitle: String = "", secondTitle: String = "", thirdTitle: String = "", _ firstAction: ActionSheetAction? = nil, _ secondAction: ActionSheetAction? = nil, _ thirdAction: ActionSheetAction? = nil, cancelCompletionAction: ActionSheetAction? = nil) {
        /// Dismissing the current alertviewcontroller if there is the one visible on the screen
        if let presenting = self.presentingViewController as? UIAlertController {
            presenting.dismiss(animated: false, completion: nil)
        }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: firstTitle, style: .default, handler: firstAction))
        if !secondTitle.isEmpty {
            actionSheet.addAction(UIAlertAction(title: secondTitle, style: .default, handler: secondAction))
        }
        if !thirdTitle.isEmpty {
            actionSheet.addAction(UIAlertAction(title: thirdTitle, style: .default, handler: thirdAction))
        }
        actionSheet.addAction(UIAlertAction(title: "CANCEL_ACTION_TITLE".localized, style: .cancel, handler: cancelCompletionAction))
        actionSheet.view.tintColor = UIColor.primaryColor
        present(actionSheet, animated: true)
    }
}
