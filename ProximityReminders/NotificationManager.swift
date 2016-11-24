//
//  NotificationManager.swift
//  ProximityReminders
//
//  Created by Joey on 24/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

struct NotificationManager {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let notificationCenter = UNUserNotificationCenter.current()
    
    //---------------------
    //MARK: Functions
    //---------------------
    func addLocationEvent(forReminder reminder: Reminder, whenLeaving: Bool) -> UNLocationNotificationTrigger? {
        
        if let location = reminder.location, let identifier = reminder.identifier {
            
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = CLCircularRegion(center: center, radius: 50, identifier: identifier)
            
            switch whenLeaving {
                
            case true:
                region.notifyOnExit = true
                region.notifyOnEntry = false
                
            case false:
                region.notifyOnExit = false
                region.notifyOnEntry = true
            }
            return UNLocationNotificationTrigger(region: region, repeats: false)
        }
        return nil
    }
    
    func scheduleNewNotification(withReminder reminder: Reminder, locationTrigger trigger: UNLocationNotificationTrigger?) {
        
        if let text = reminder.text, let identifier = reminder.identifier, let notificationTrigger = trigger {
            
            let content = UNMutableNotificationContent()
            content.body = text
            content.sound = UNNotificationSound.default()
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
            
            notificationCenter.add(request)
        }
    }
    
}
