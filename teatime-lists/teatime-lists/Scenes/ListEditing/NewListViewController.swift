//
//  NewListViewController.swift
//  placetest
//
//  Created by Benjamin Vigier on 9/14/18.
//  Copyright © 2018 Benjamin Vigier. All rights reserved.
//

import UIKit
import GrowingTextView
import ProgressHUD

class NewListViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var listTitleTextField: UITextField!
    @IBOutlet weak var titleExampleLabel: UILabel!
    @IBOutlet weak var listDescriptionTextView: GrowingTextView!
    @IBOutlet weak var descriptionExampleLabel: UILabel!
    @IBOutlet weak var createListButton: UIButton!
    
    
    //Constraints
    @IBOutlet weak var createListButtonBottomConstraint: NSLayoutConstraint!
    
    
    //Set by the HomeListVC during prepareForSegue
    var completionCallBackHandle: ((ListModel?)->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createListButton.layer.borderWidth = 1.0
        createListButton.setTitleColor(UIColor(red: 216.0/255, green: 99.0/255, blue: 140.0/255, alpha: 1.0), for: .normal)
        createListButton.setTitleColor(UIColor(red: 192.0/255, green: 192.0/255, blue: 192.0/255, alpha: 1.0), for: .disabled)
        createListButton.layer.cornerRadius = createListButton.frame.height / 2
        changeCreateListButtonState(enabled: false)
        
        listDescriptionTextView.delegate = self
        //Registering to the event editingChange
        listTitleTextField.addTarget(self, action: #selector(listTitleTextChanged), for: .editingChanged)
        //Registering to the event keyboardWillHide
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: NSNotification.Name.UIKeyboardDidChangeFrame,
            object: nil
        )
        
        listTitleTextField.becomeFirstResponder()
    }
    
    @objc func keyboardDidShow(notification: NSNotification){
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            createListButtonBottomConstraint.constant = keyboardHeight + 10
        }
    }
        
    
    @objc func listTitleTextChanged(){
        if let text = listTitleTextField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty{
            //hiding the title example label
            titleExampleLabel.isHidden = true
            changeCreateListButtonState(enabled: true)
        } else {
            titleExampleLabel.isHidden = false
            changeCreateListButtonState(enabled: false)
        }
    }
    

    //Enables/disabled the Create List Button
    func changeCreateListButtonState(enabled: Bool){
        if enabled{
            createListButton.layer.borderColor = UIColor(red: 216.0/255, green: 99.0/255, blue: 140.0/255, alpha: 1.0).cgColor
            createListButton.isEnabled = true
            return
        }
        createListButton.layer.borderColor = UIColor(red: 192.0/255, green: 192.0/255, blue: 192.0/255, alpha: 1.0).cgColor
        createListButton.isEnabled = false
    }
    
  
    @IBAction func createListButtonTapped(_ sender: Any) {
        print("CREATE LIST BUTTON TAPPED")
        view.endEditing(true)
       
       guard let user = ParseHelper.currentUser, let userID = user.objectId else {
            print("ERROR OCCURED WHILE CREATING A NEW LIST")
            alertWithTitle(title: "Oops!", message: "You are not logged in. Please log in and try again.")
            dismiss(animated: true, completion: { [weak self] in self?.completionCallBackHandle?(nil) })
            return
        }
        
        guard let titleText = listTitleTextField.text?.trimmingCharacters(in: .whitespaces), !titleText.isEmpty else {
            print("ERROR OCCURED WHILE CREATING A NEW LIST")
            alertWithTitle(title: "Oops!", message: "Something went wrong, please try again")
            dismiss(animated: true, completion: { [weak self] in self?.completionCallBackHandle?(nil) })
            return
        }
        
        let newList = ListModel(user: user, title: titleText)
        if let descriptionText = listDescriptionTextView.text?.trimmingCharacters(in: .whitespaces), !descriptionText.isEmpty{
            newList.listDescription = descriptionText
        }
        
        //Saving the list in Parse
        ProgressHUD.show()
        ParseHelper.singleton.createList(list: newList) { [weak self] (success, error) in
            ProgressHUD.dismiss()
            guard let wself = self else { return }
            if !success{
                if let error = error{
                    print("ERROR OCCURED WHILE SAVING THE NEW LIST IN PARSE: ", error)
                }
                wself.alertWithTitle(title: "Oops!", message: "Something went wrong, please try again")
                return
            }
            
            print("LIST WAS SUCCESSFULLY SAVED - ID = ", newList.objectId ?? "None")
            wself.dismiss(animated: true) { [wself] in
                wself.completionCallBackHandle?(newList)
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: { [weak self] in
            self?.completionCallBackHandle?(nil)
            
        })
    }
    

}



extension NewListViewController: GrowingTextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = listDescriptionTextView.text, !text.isEmpty{
            //hiding the title example label
            descriptionExampleLabel.isHidden = true
        } else {
            descriptionExampleLabel.isHidden = false
        }
    }

}
