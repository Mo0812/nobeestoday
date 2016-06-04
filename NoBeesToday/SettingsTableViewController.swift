//
//  SettingsTableViewController.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 01.06.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var identifier: [(String, String, NSDate?)] = [(String, String, NSDate?)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        identifier = [("Einnahmezeit pro Tag", "takingTimePerDay", GlobalValues.takingTimePerDay), ("Erste Pilleneinnahme", "firstTakingDate", GlobalValues.fristTakingDate)]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        identifier = [("Einnahmezeit pro Tag", "takingTimePerDay", GlobalValues.takingTimePerDay), ("Erste Pilleneinnahme", "firstTakingDate", GlobalValues.fristTakingDate)]
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return identifier.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TakingPerDaySettings", forIndexPath: indexPath)

        // Configure the cell...
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "de_DE")
        
        let element = identifier[indexPath.row]
        cell.textLabel?.text = element.0
        
        switch(element.1) {
            case "takingTimePerDay":
                formatter.dateFormat = "HH:mm"
                break;
            case "firstTakingDate":
                formatter.dateFormat = "dd.MM.YYYY"
                break;
            default:
                formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
        }
        if let date = element.2 {
            cell.detailTextLabel?.text = formatter.stringFromDate(date)
        }
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? SettingsDetailViewController {
            if let cell = sender as? UITableViewCell {
                if let index = tableView.indexPathForCell(cell) {
                    dest.element = identifier[index.row]
                }
            }
        }
    }
    

}
