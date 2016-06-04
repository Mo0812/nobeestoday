//
//  Settings.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 01.06.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import Foundation

class Settings {
    
    static func loadSavedValues() -> Bool {
        if let ftd = NSUserDefaults.standardUserDefaults().objectForKey("firstTakingDate"), ttpd = NSUserDefaults.standardUserDefaults().objectForKey("takingTimePerDay") {
            GlobalValues.fristTakingDate = ftd as! NSDate
            GlobalValues.takingTimePerDay = ttpd as! NSDate
            return true
        } else {
            return false
        }
    }
    
    static func changeSavedValues() {
        NSUserDefaults.standardUserDefaults().setObject(GlobalValues.fristTakingDate, forKey: "firstTakingDate")
        NSUserDefaults.standardUserDefaults().setObject(GlobalValues.takingTimePerDay, forKey: "takingTimePerDay")
    }
    
}