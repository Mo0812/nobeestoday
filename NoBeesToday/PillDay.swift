//
//  PillDay.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 29.05.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PillDay: NSManagedObject {
    
    enum PillDayState: NSNumber {
        case PillTaken = 0
        case PillBlood = 1
        case PillForgotten = 2
        case PillNotTaken = 3
    }
    
    @NSManaged var date: NSDate?
    @NSManaged var state: NSNumber?
    
    func getPillState() -> PillDayState {
        if state == 0 {
            return .PillTaken
        } else if state == 1 {
            return .PillBlood
        } else {
            return .PillForgotten
        }
    }
    
}