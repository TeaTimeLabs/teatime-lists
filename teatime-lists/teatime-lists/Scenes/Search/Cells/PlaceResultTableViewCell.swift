//
//  PlaceResultTableViewCell.swift
//  teatime-lists
//
//  Created by Mathieu Perrais on 9/25/18.
//  Copyright © 2018 Tea Time Labs Inc. All rights reserved.
//

import UIKit

final class PlaceResultTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var placeDescriptionLabel: UILabel!
    
    var place: Place? {
        didSet{
            placeDidSet()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.alpha = 0.2
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func placeDidSet(){
        guard let place = self.place else{ return }
        
        renderPlaceIcon()
        
        placeNameLabel.text = place.name
        var description = place.category.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter()
        
        if !description.isEmpty{
            if !place.shortAddress.isEmpty{
                description += " • \(place.shortAddress)"
            } else { placeDescriptionLabel.text = place.category.replacingOccurrences(of: "_", with: " ") }
        } else {
            description = "\(place.shortAddress)"
        }
        
        placeDescriptionLabel.text = description
    }
    
    func renderPlaceIcon(){
        guard let place = self.place else{ return }
        
        if place.category.isEmpty{
            iconImageView.image = #imageLiteral(resourceName: "default-category")
            return
        }
        let iconName = String.underscoreToDash(text: place.category)
        if let iconImage = UIImage(named: iconName){
            iconImageView.image = iconImage
        } else{
            iconImageView.image = #imageLiteral(resourceName: "default-category")
        }
    }

    
}
