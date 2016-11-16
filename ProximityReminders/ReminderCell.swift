//
//  ReminderCell.swift
//  ProximityReminders
//
//  Created by Joey on 09/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    //---------------------
    //MARK: Variabels
    //---------------------
    @IBOutlet weak var completedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //Set the image of the checkmark for selected and unSelected state
        self.completedImage.image = selected ? UIImage(named: "selected") : UIImage(named: "unSelected")
    }

}
