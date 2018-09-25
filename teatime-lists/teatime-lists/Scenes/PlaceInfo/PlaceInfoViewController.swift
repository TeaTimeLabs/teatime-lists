//
//  PlaceInfoViewController.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

class PlaceInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var categoryLabel: UILabel?
    @IBOutlet var hoursLabel: UILabel?
    @IBOutlet var followersLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel?.font = UIFont.poppinsMedium(fontSize: 21)
        nameLabel?.textColor = UIColor.darkTextColor
        
        categoryLabel?.font = UIFont.poppinsRegular(fontSize: 14)
        categoryLabel?.textColor = UIColor.lightTextColor
    }

    func changeContent(place: Place) {
        nameLabel?.text = place.name
        categoryLabel?.text = place.category
        hoursLabel?.text = ""
        followersLabel?.text = ""
    }

}
