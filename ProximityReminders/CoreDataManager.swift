//
//  CoreDataManager.swift
//  ProximityReminders
//
//  Created by Joey on 09/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

public class CoreDataManager {
    
    //Shared instance
    static let sharedInstance = CoreDataManager()
    
    //----------------------
    //MARK: Core Data Stack
    //----------------------
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ProximityReminders")
        container.loadPersistentStores(completionHandler: { storeDiscriptor, error in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        return self.persistentContainer.viewContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Reminder> = {
        
        let fetchRequest: NSFetchRequest = Reminder.fetchRequest()
        let sortDiscriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDiscriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    //----------------------
    //MARK: Saving
    //----------------------
    func saveContext() {
        
        if self.managedObjectContext.hasChanges {
            
            do {
                try self.managedObjectContext.save()
                print("Save successfull")
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }else {
            print("Does not have changes")
        }
    }
    
    //Save Reminder
    func saveReminder(withText text: String, andLocation location: CLLocation?) {
        
        let reminder = Reminder(entity: Reminder.entity(), insertInto: self.managedObjectContext)
        reminder.text = text
        reminder.date = NSDate()
        reminder.identifier = String(describing: Date())
        
        if let location = location {
            reminder.location = self.saveLocation(location: location)
        }
        
        self.saveContext()
    }
    
    //Save location
    func saveLocation(location: CLLocation) -> Location {
        
        let loc = Location(entity: Reminder.entity(), insertInto: self.managedObjectContext)
        
        loc.latitude = location.coordinate.latitude
        loc.longitude = location.coordinate.longitude
        
        return loc
    }
    
    //----------------------
    //MARK: Deleting
    //----------------------
    func deleteReminder(reminder: Reminder) {
        
        managedObjectContext.delete(reminder)
        self.saveContext()
    }

    
}


































