//
//  ReminderDetailTableViewController.swift
//  ProximityReminders
//
//  Created by Joey on 15/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
    
    //---------------------
    //MARK: Variables
    //---------------------
    
    
    //---------------------
    //MARK: Outlets
    //---------------------
    @IBOutlet weak var titleCell: ReminderTitleCell!
    @IBOutlet weak var locationCell: UITableViewCell!
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navigation bar
        navigationItem.title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveReminder))
        
        //Customise tableview
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Set textview delegate to title cell
        titleCell.textView.delegate = self

    }

    //---------------------
    //MARK: Table View
    //---------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            performSegue(withIdentifier: "SearchLocationView", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            if titleCell.textView.text.characters.count == 0 {
                return 44.0
            }else {
                return UITableViewAutomaticDimension
            }
        }else if indexPath.section == 1 && indexPath.row == 1 {
            
            return 64.0
        }
        
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    //---------------------
    //MARK: Button Actions
    //---------------------
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            sender.setOn(false, animated: true)
            locationCell.isHidden = true
            
        }else {
            sender.setOn(true, animated: true)
            locationCell.isHidden = false
        }
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    @objc func saveReminder() {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//---------------------
//MARK: Extension
//---------------------
extension ReminderDetailViewController: UITextViewDelegate {
    
    //Update tableview cell when user is typing
    func textViewDidChange(_ textView: UITextView) {

        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}
