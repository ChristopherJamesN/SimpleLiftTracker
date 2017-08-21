//
//  ExcerciseDescriptionViewCell.swift
//  FoodTracker
//
//  Created by Christopher Nady on 8/1/17.
//  Copyright © Nady Analytics, LLC. All rights reserved.
//

import UIKit

class ExcerciseDescriptionViewCell: UITableViewCell {
    
    @IBOutlet var excerciseDescription: UILabel!
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var repsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        excerciseDescription.adjustsFontForContentSizeCategory = true
        setsLabel.adjustsFontForContentSizeCategory = true
        repsLabel.adjustsFontForContentSizeCategory = true
        
        
    }

}
