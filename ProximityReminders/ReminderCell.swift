//
//  ReminderCell.swift
//  ProximityReminders
//
//  Created by Joey on 09/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(withReminder reminder: Reminder) {
        
        self.titleLabel.text = reminder.text
    }

}
