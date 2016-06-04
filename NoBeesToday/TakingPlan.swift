//
//  TakingPlan.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 30.05.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TakingPlan {
        
    init(from: NSDate) {
        self.cleanUpData(from)
    }
    
    func addDay(date: NSDate, state: PillDay.PillDayState) {
        let rState = state.rawValue
        
        let moc = DataController().managedObjectContext
        let newDay = NSEntityDescription.insertNewObjectForEntityForName("PillDay", inManagedObjectContext: moc) as! PillDay
        newDay.setValue(calcDictDate(date), forKey: "date")
        newDay.setValue(rState, forKey: "state")
        
        do {
            try moc.save()
        } catch {
            print("Fehler beim Einfügen")
        }
    }
    
    func getDay(date: NSDate) -> PillDay? {
        
        let moc = DataController().managedObjectContext
        let pillDayFetch = NSFetchRequest(entityName: "PillDay")
        let predicate = NSPredicate(format: "date == %@", calcDictDate(date))
        pillDayFetch.predicate = predicate
        
        do {
            let result = try moc.executeFetchRequest(pillDayFetch) as! [PillDay]
            if result.count > 0 {
                return result.first!
            }
        } catch {
            print("Fehler beim Abfragen")
        }
        
        return nil
    }
    
    func takenAtDay(date: NSDate) -> Bool {
        let moc = DataController().managedObjectContext
        let pillDayFetch = NSFetchRequest(entityName: "PillDay")
        let predicate = NSPredicate(format: "date == %@", calcDictDate(date))
        pillDayFetch.predicate = predicate
        
        do {
            let result = try moc.executeFetchRequest(pillDayFetch) as! [PillDay]
            if result.count > 0 {
                if result.first!.getPillState() == PillDay.PillDayState.PillTaken {
                    return true
                }
            }
        } catch {
            print("Fehler beim Abfragen")
        }
        
        return false
    }
    
    func clearAll() {
        let moc = DataController().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "PillDay")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.executeRequest(deleteRequest)
            print("Alle Einträge gelöscht")
        } catch {
            print("Löschen fehlgeschlagen")
        }
    }
    
    func getCycle(from: NSDate) -> [PillDayModel] {
        self.cleanUpData(from)
        var returnVal = [PillDayModel]()
        
        let calendar = NSCalendar.currentCalendar()
        //calendar.locale = NSLocale(localeIdentifier: "de_DE")
        
        var lookAtDay = self.calcDictDate(from)
        for i in 0..<28 {
            if let thisDay = self.getDay(lookAtDay) {
                returnVal.append(PillDayModel(date: thisDay.date!, state: thisDay.getPillState()))
            } else {
                returnVal.append(PillDayModel(date: lookAtDay, state: PillDay.PillDayState.PillNotTaken))
            }
            let components = NSDateComponents()
            components.day = 1
            
            lookAtDay = calendar.dateByAddingComponents(components, toDate: lookAtDay, options: NSCalendarOptions(rawValue: 0))!
        }
        
        return returnVal
    }
    
    func cleanUpData(from: NSDate) {
        let today = calcDictDate(NSDate())
        let calendar = NSCalendar.currentCalendar()
        //calendar.locale = NSLocale(localeIdentifier: "de_DE")
        
        var lookAtDay = self.calcDictDate(from)
        for i in 0..<28 {
            if (i>20) {
                self.addDay(lookAtDay, state: PillDay.PillDayState.PillBlood)
            }
            if today.compare(lookAtDay) == .OrderedDescending {
                self.addDay(lookAtDay, state: PillDay.PillDayState.PillForgotten)
            }
            
            
            
            let components = NSDateComponents()
            components.day = 1
            
            lookAtDay = calendar.dateByAddingComponents(components, toDate: lookAtDay, options: NSCalendarOptions(rawValue: 0))!
        }
    }
    
    private func calcDictDate(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        let rightDate = calendar.dateFromComponents(components)
        return rightDate!
    }
}