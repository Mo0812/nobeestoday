//
//  StartUpViewController.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 02.06.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {

    @IBOutlet weak var defaultKey: UILabel!
    @IBOutlet weak var defaultValue: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var identifier: [(String, String, NSDate?)] = [("Einnahmezeit pro Tag", "takingTimePerDay", nil), ("Erste Pilleneinnahme", "firstTakingDate", nil)]
    var currentID: (String, String, NSDate?)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentID = identifier[0]
        defaultKey.text = currentID!.0
        datePicker.datePickerMode = .Time
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeDefaultValue(sender: AnyObject) {
        if let setting = currentID {
            switch setting.1 {
            case "takingTimePerDay":
                currentID = identifier[1]
                defaultKey.text = currentID!.0
                datePicker.datePickerMode = .Date
                break;
            case "firstTakingDate":
                Settings.changeSavedValues()
                GlobalValues.takingPlan = TakingPlan(from: GlobalValues.fristTakingDate!)
                performSegueWithIdentifier("showMainScreenSegue", sender: self)
                break;
            default:
                return;
            }
        }
    }

    @IBAction func pickerHasChanged(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "de_DE")
        
        if let setting = currentID {
            switch setting.1 {
            case "takingTimePerDay":
                formatter.dateFormat = "HH:mm:ss"
                GlobalValues.setTimePerDay(formatter.stringFromDate(datePicker.date))
                formatter.dateFormat = "HH:mm"
                defaultValue.text = formatter.stringFromDate(datePicker.date)
                break;
            case "firstTakingDate":
                GlobalValues.setFirstTakingDate(datePicker.date)
                formatter.dateFormat = "dd.MM.YYYY"
                defaultValue.text = formatter.stringFromDate(datePicker.date)
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
