//
//  TakingViewController.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 29.05.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import UIKit

class TakingViewController: UIViewController {
    
    @IBOutlet weak var pillLabel: UILabel!
    @IBOutlet weak var pillTimer: UILabel!
    
    let formatter = NSDateFormatter()
    var timeDiff: NSTimeInterval = 0.0
    var dateTarget: NSTimeInterval = 0.0
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.updateTimeDiff()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TakingViewController.updateTimeDiff), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let pillTakingTimer = self.timer {
            timer!.invalidate()
            timer = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimeDiff() {
        if(GlobalValues.takingPlan!.takenAtDay(NSDate())) {
            self.pillLabel.text = "Für heute ist alles:"
            self.pillLabel.textColor = UIColor.grayColor()
            self.pillTimer.text = "Erledigt"
            self.pillTimer.textColor = UIColor.blackColor()
        } else {
            self.timeDiff = NSDate.timeIntervalSinceReferenceDate() - GlobalValues.getTimePerDayAsInterval()
            
            var timeDiff = self.timeDiff
            
            let hours = Int(timeDiff / 3600)
            timeDiff -= NSTimeInterval(hours) * 3600
            let minutes = Int(timeDiff / 60)
            timeDiff -= NSTimeInterval(minutes) * 60
            let seconds = Int(timeDiff)
            
            let numberFormatter = NSNumberFormatter()
            numberFormatter.minimumIntegerDigits = 2
            
            self.pillTimer.text = "\(numberFormatter.stringFromNumber(hours)!):\(numberFormatter.stringFromNumber(abs(minutes))!):\(numberFormatter.stringFromNumber(abs(seconds))!)"
            
            if(hours > 0 || minutes > 0 || seconds > 0) {
                self.pillTimer.textColor = UIColor.redColor()
                self.pillLabel.text = "Du hast deine Pille noch nicht genommen:"
            } else {
                self.pillTimer.textColor = UIColor.blackColor()
                self.pillLabel.text = "Zeit bis zur Pilleneinnahme:"
            }
        }
    }
    
    @IBAction func pillTaken(sender: AnyObject) {
        GlobalValues.takingPlan?.addDay(NSDate(), state: PillDay.PillDayState.PillTaken)
        NotificationService.cancelStressNotificationsOnForgotten()
    }
    
}
