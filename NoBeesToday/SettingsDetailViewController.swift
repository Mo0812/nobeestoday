//
//  SettingsDetailViewController.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 02.06.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UIViewController {

    @IBOutlet weak var settingsKey: UILabel!
    @IBOutlet weak var settingsValue: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var element: (String, String, NSDate?)?
    var pickerChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.hidden = true
        if let setting = element {
            settingsKey.text = setting.0
            
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "de_DE")
            switch setting.1 {
            case "takingTimePerDay":
                formatter.dateFormat = "HH:mm";
                datePicker.datePickerMode = .Time
                break;
            case "firstTakingDate":
                formatter.dateFormat = "dd.MM.YYYY"
                datePicker.datePickerMode = .Date
                
                break;
            default:
                formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
                
            }
            
            if let date = setting.2 {
                settingsValue.text = formatter.stringFromDate(date)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        Settings.changeSavedValues()
        if let setting = element {
            if setting.1 == "firstTakingDate" && self.pickerChanged {
                GlobalValues.takingPlan?.clearAll()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openChangeDialog(sender: AnyObject) {
        if let setting = element {
            if setting.1 == "firstTakingDate" {
                let alert = UIAlertController(title: "Datum wirklich ändern?", message:
                    "Wenn das Datum wirklich geändert wird, gehen alle bisherigen Daten verloren, wirklich ändern?", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Doch nicht", style: .Default, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {
                    void in
                    self.datePicker.hidden = false
                    self.pickerChanged = true
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                datePicker.hidden = false
            }
        }
    }

    @IBAction func datePickerChanged(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "de_DE")
        
        if let setting = element {
            switch setting.1 {
            case "takingTimePerDay":
                formatter.dateFormat = "HH:mm:ss"
                GlobalValues.setTimePerDay(formatter.stringFromDate(datePicker.date))
                formatter.dateFormat = "HH:mm"
                settingsValue.text = formatter.stringFromDate(datePicker.date)
                break;
            case "firstTakingDate":
                GlobalValues.setFirstTakingDate(datePicker.date)
                formatter.dateFormat = "dd.MM.YYYY"
                settingsValue.text = formatter.stringFromDate(datePicker.date)
                break;
            default:
                return;
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
