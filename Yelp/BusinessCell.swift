//
//  BusinessCell.swift
//  Yelp
//
//  Created by Phuong Thao Tran on 2/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business! {
        didSet {
            businessImage.setImageWith(business.imageURL!)
            businessLabel.text = business.name
            distanceLabel.text = business.distance
            reviewImage.setImageWith(business.ratingImageURL!)
            reviewCountLabel.text = "\(business.reviewCount!)"
            addressLabel.text = business.address
            categoryLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
