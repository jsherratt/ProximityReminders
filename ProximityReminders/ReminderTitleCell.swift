//
//  ReminderTitleCell.swift
//  ProximityReminders
//
//  Created by Joey on 16/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class ReminderTitleCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
