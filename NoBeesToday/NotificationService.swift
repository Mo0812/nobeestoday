//
//  NotificationService.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 01.06.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import Foundation
import UIKit

class NotificationService {
    
    static func setNotificationForTakingPerDay() {
        
        let app = UIApplication.sharedApplication()
        if let searchedNotifications = app.scheduledLocalNotifications {
            for thisNotification in searchedNotifications {
                if let userinfo = thisNotification.userInfo as? [String: String] {
                    if userinfo["style"] == "pillPerDay" {
                        app.cancelLocalNotification(thisNotification)
                    }
                }
            }

        }
        
        let notification = UILocalNotification()
        notification.alertBody = "💊 Zeit für die Pille"
        notification.alertAction = "Öffnen"
        notification.category = "PILL_CATEGORY"
        notification.fireDate = NSDate(timeIntervalSinceReferenceDate: GlobalValues.getTimePerDayAsInterval())
        notification.repeatInterval = NSCalendarUnit.Day
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["style": "pillPerDay"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        cancelAllStressNotifications()
        setStressNotificationsOnForgotten(GlobalValues.getTimePerDayAsInterval())
    }
    
    static func setStressNotificationsOnForgotten(forDay: NSTimeInterval) {
        let notification1 = UILocalNotification()
        notification1.alertBody = "💊 Du hast die Pille noch immer nicht genommen!"
        notification1.alertAction = "Öffnen"
        notification1.category = "PILL_CATEGORY"
        notification1.fireDate = NSDate(timeIntervalSinceReferenceDate: forDay+60)
        notification1.repeatInterval = NSCalendarUnit.Hour
        notification1.soundName = UILocalNotificationDefaultSoundName
        notification1.userInfo = ["style": "pillStressAlert"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification1)
        
        let notification2 = UILocalNotification()
        notification2.alertBody = "💊 Los Los 😇"
        notification2.alertAction = "Öffnen"
        notification2.category = "PILL_CATEGORY"
        notification2.fireDate = NSDate(timeIntervalSinceReferenceDate: forDay+60*5)
        notification2.repeatInterval = NSCalendarUnit.Hour
        notification2.soundName = UILocalNotificationDefaultSoundName
        notification2.userInfo = ["style": "pillStressAlert"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification2)
        
        let notification3 = UILocalNotification()
        notification3.alertBody = "💊 Jetzt nimm endlich die Pille!"
        notification3.alertAction = "Öffnen"
        notification3.category = "PILL_CATEGORY"
        notification3.fireDate = NSDate(timeIntervalSinceReferenceDate: forDay+60*20)
        notification3.repeatInterval = NSCalendarUnit.Hour
        notification3.soundName = UILocalNotificationDefaultSoundName
        notification3.userInfo = ["style": "pillStressAlert"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification3)
    }
    
    static func cancelAllStressNotifications() {
        let app = UIApplication.sharedApplication()
        if let searchedNotifications = app.scheduledLocalNotifications {
            for thisNotification in searchedNotifications {
                if let userinfo = thisNotification.userInfo as? [String: String] {
                    if userinfo["style"] == "pillStressAlert" {
                        app.cancelLocalNotification(thisNotification)
                    }
                }
            }
            
        }
    }
    
    static func cancelStressNotificationsOnForgotten() {
        let app = UIApplication.sharedApplication()
        if let searchedNotifications = app.scheduledLocalNotifications {
            for thisNotification in searchedNotifications {
                if let userinfo = thisNotification.userInfo as? [String: String] {
                    if userinfo["style"] == "pillStressAlert" {
                        app.cancelLocalNotification(thisNotification)
                    }
                }
            }
            
        }
        
        setStressNotificationsOnForgotten(GlobalValues.getTimePerDayAsInterval()+60*60*24)
    }
}