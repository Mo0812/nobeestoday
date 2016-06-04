//
//  MainViewController.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 28.05.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import UIKit

class TakingPlanViewController: UIViewController {
    
    var takingPlanRaw: [PillDayModel]?
    
    @IBOutlet weak var pillView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pillView.dataSource = self
                
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        takingPlanRaw = GlobalValues.takingPlan?.getCycle(GlobalValues.fristTakingDate!)
        pillView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func firstTaking(sender: AnyObject) {
        //self.takingPlan = GlobalValues.takingPlan!.getCycle(GlobalValues.fristTakingDate!)
        //pillView.reloadData()
        //takingPlan.addDay(NSDate(), state: 0)
    }
    
    
}

extension TakingPlanViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CVCell", forIndexPath: indexPath) as! PillCalendarCell
        if let tp = self.takingPlanRaw {
            let element = tp[indexPath.row]
            if(element.state == PillDay.PillDayState.PillTaken) {
                cell.pillImage.image = UIImage(named: "pill-taken")
            } else if(element.state == PillDay.PillDayState.PillBlood) {
                cell.pillImage.image = UIImage(named: "blood")
            } else if (element.state == PillDay.PillDayState.PillForgotten) {
                cell.pillImage.image = UIImage(named: "pill-forgotten")
            } else {
                cell.pillImage.image = UIImage(named: "pill-not-taken")
            }
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "de_DE")
            formatter.dateFormat = "EE"
            cell.weekdayLabel.text = formatter.stringFromDate(element.date!)
            formatter.dateFormat = "dd.MM."
            
            
            if element.date == GlobalValues.normalizeDate(NSDate()) {
                let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
                let underlineAttributedString = NSAttributedString(string: formatter.stringFromDate(element.date!), attributes: underlineAttribute)
                cell.dateLabel.attributedText = underlineAttributedString
            } else {
                cell.dateLabel.text = formatter.stringFromDate(element.date!)
            }
        }
        return cell
    }
    
}
