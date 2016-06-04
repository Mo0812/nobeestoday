//
//  File.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 29.05.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import Foundation
import UIKit

class GlobalValues {
    static var fristTakingDate: NSDate?
    static var takingTimePerDay: NSDate?
    static var takingPlan: TakingPlan?
    
    static func setTimePerDay(timePerDay: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        self.takingTimePerDay = dateFormatter.dateFromString(timePerDay)
        NotificationService.setNotificationForTakingPerDay()
    }
    
    static func getTimePerDayAsInterval() -> NSTimeInterval {
        let calender = NSCalendar.currentCalendar()
        calender.locale = NSLocale(localeIdentifier: "de_DE")
        let componentsPillTime = calender.components([.Hour, .Minute, .Second], fromDate: GlobalValues.takingTimePerDay!)
        let componentsNowTime = calender.components([.Year, .Month, .Day], fromDate: NSDate())
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateTargetNSD = formatter.dateFromString("\(componentsNowTime.year)-\(componentsNowTime.month)-\(componentsNowTime.day) \(componentsPillTime.hour):\(componentsPillTime.minute):\(componentsPillTime.second)")
        
        return dateTargetNSD!.timeIntervalSinceReferenceDate
    }
    
    static func setFirstTakingDate(date: NSDate) {
        self.fristTakingDate = normalizeDate(date)
        //self.takingPlan?.getCycle(self.fristTakingDate!)
    }
    
    static func normalizeDate(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        let rightDate = calendar.dateFromComponents(components)
        return rightDate!
    }
    
    
}
