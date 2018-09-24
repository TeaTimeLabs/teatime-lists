//
//  ListInfoTableViewCell.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/21/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit
import Kingfisher

class ListInfoTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var placeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor.darkTextColor
        authorLabel.textColor = UIColor.lightTextColor
        placeCountLabel.textColor = UIColor.lightTextColor
        
        titleLabel.font = UIFont.poppinsMedium(fontSize: 16)
        authorLabel.font = UIFont.poppinsRegular(fontSize: 14)
        placeCountLabel.font = UIFont.poppinsRegular(fontSize: 13)
        
        authorImageView.layer.cornerRadius = authorImageView.frame.width / 2
        authorImageView.clipsToBounds = true
    }
    
    func configure(listModel: ListModel) {
        titleLabel.text = listModel.title
        authorLabel.text = "by " + listModel.user.firstname
        placeCountLabel.text = "\(listModel.placeItems.count) PLACES"
        
        let url = URL(string: listModel.user.photoURL)
        authorImageView.kf.setImage(with: url)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
