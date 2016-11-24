//
//  ReminderTableViewController.swift
//  ProximityReminders
//
//  Created by Joey on 08/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreData

class ReminderTableViewController: UITableViewController {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let coreDataManager = CoreDataManager.sharedInstance
    var selectedReminder: Reminder?
    
    //---------------------
    //MARK: View
    //---------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customise navigation bar
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = "Reminders"
        
        //Customise  tableview
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Set fetched results controller delegate
        coreDataManager.fetchedResultsController.delegate = self
        
        fetchResults()

    }

    //---------------------
    //MARK: Table View
    //---------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let reminders = coreDataManager.fetchedResultsController.fetchedObjects?.count {
            
            return reminders
            
        }else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
        
        let reminder = coreDataManager.fetchedResultsController.object(at: indexPath)
        cell.configure(withReminder: reminder)
        
        print(reminder.entity.description)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedReminder = coreDataManager.fetchedResultsController.object(at: indexPath)
        
        performSegue(withIdentifier: "ReminderDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            let reminder = coreDataManager.fetchedResultsController.object(at: indexPath)
            coreDataManager.deleteReminder(reminder: reminder)
        }
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    @IBAction func createNewReminder(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Reminder", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { saveAction in
            let textField = alertController.textFields![0] as UITextField
            self.coreDataManager.saveReminder(withText: textField.text!, andLocation: nil)
        }
        saveAction.isEnabled = false
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter a reminder title"
            NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using: { (notification) in
                saveAction.isEnabled = textField.text != ""
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    func fetchResults() {
        
        do {
            try coreDataManager.fetchedResultsController.performFetch()
            
        }catch let error as NSError {
            
            showAlert(with: "Error", andMessage: "\(error.localizedDescription)")
        }
    }
    
    //---------------------
    //MARK: Navigation
    //---------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ReminderDetail" {
            
            let reminderDetailVc = segue.destination as! ReminderDetailViewController
            
            reminderDetailVc.reminder = selectedReminder
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//---------------------
//MARK: Extension
//---------------------
extension ReminderTableViewController: NSFetchedResultsControllerDelegate {
    
    //-------------------------------
    //MARK: Fetched Results Delegate
    //-------------------------------
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.reloadData()
    }
}































