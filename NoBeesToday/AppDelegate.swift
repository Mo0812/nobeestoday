//
//  AppDelegate.swift
//  NoBeesToday
//
//  Created by Moritz Kanzler on 28.05.16.
//  Copyright © 2016 Moritz Kanzler. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let completeAction = UIMutableUserNotificationAction()
        completeAction.identifier = "PILL_TAKEN" // the unique identifier for this action
        completeAction.title = "Pille genommen" // title for the action button
        completeAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        completeAction.authenticationRequired = false // don't require unlocking before performing action
        completeAction.destructive = false // display action in red
        
        let remindAction = UIMutableUserNotificationAction()
        remindAction.identifier = "REMIND"
        remindAction.title = "Später erinnern"
        remindAction.activationMode = .Background
        remindAction.destructive = true
        
        let pillCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
        pillCategory.identifier = "PILL_CATEGORY"
        pillCategory.setActions([completeAction, remindAction], forContext: .Default) // UIUserNotificationActionContext.Default (4 actions max)
        pillCategory.setActions([remindAction, completeAction], forContext: .Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: (NSSet(array: [pillCategory])) as? Set<UIUserNotificationCategory>))
        
        if(Settings.loadSavedValues()) {
        
            if(GlobalValues.fristTakingDate!.dateByAddingTimeInterval(60*60*24*28).timeIntervalSinceReferenceDate < NSDate().timeIntervalSinceReferenceDate) {
                GlobalValues.setFirstTakingDate(GlobalValues.fristTakingDate!.dateByAddingTimeInterval(60*60*24*28))
                Settings.changeSavedValues()
            }
            
            GlobalValues.takingPlan = TakingPlan(from: GlobalValues.fristTakingDate!)
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController: StartUpViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! StartUpViewController
            
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
            
            print("Error Loading Defaults");
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        switch (identifier!) {
        case "PILL_TAKEN":
            GlobalValues.takingPlan?.addDay(NSDate(), state: PillDay.PillDayState.PillTaken)
            NotificationService.cancelStressNotificationsOnForgotten()
            break;
        case "REMIND":
            print("Weiter")
            break;
        default: // switch statements must be exhaustive - this condition should never be met
            print("Error: unexpected notification action identifier!")
        }
        completionHandler() // per developer documentation, app will terminate if we fail to call this
    }
    
}

