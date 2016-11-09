//
//  ReminderTableViewController.swift
//  ProximityReminders
//
//  Created by Joey on 08/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit

class ReminderTableViewController: UITableViewController {
    
    //---------------------
    //MARK: Variables
    //---------------------
    
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //---------------------
    //MARK: Table View
    //---------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
