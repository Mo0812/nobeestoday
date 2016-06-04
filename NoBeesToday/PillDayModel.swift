//
//  PillDayModel.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 01.06.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import Foundation
import UIKit

class PillDayModel {
    
    var date: NSDate?
    var state: PillDay.PillDayState?
    
    init(date: NSDate, state: PillDay.PillDayState) {
        self.date = date
        self.state = state
    }
    
}