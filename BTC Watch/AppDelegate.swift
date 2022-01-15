//
//  AppDelegate.swift
//  BTC Watch
//
//  Created by Jas on 16/11/2017.
//  Copyright © 2017 Jastech Ltd. All rights reserved.
//

import UIKit
//import BackgroundTasks
//import Logger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if (UserDefaults.standard.string(forKey: "amount") == nil){
      UserDefaults.standard.set("", forKey: "ampunt")
    }

    UserDefaults.standard.synchronize()
    window?.backgroundColor = UIColor.darkGray
    
    
   /* if #available(iOS 13, *) {
      let appRefreshTaskId = "task_refresh_id_recurring_buy"
        BGTaskScheduler.shared.register(forTaskWithIdentifier: appRefreshTaskId, using: nil) { task in
            Logger.shared.info("[BGTASK] Perform bg fetch \(appRefreshTaskId)")
            task.setTaskCompleted(success: true)
            self.scheduleAppRefresh()
        }
    }*/
    
    return true
  }
  
  /*@available(iOS 13.0, *)
  func scheduleAppRefresh() {
      let request = BGAppRefreshTaskRequest(identifier: "task_refresh_id_recurring_buy")
      request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Refresh after 5 minutes.
      do {
          try BGTaskScheduler.shared.submit(request)
      } catch {
          print("Could not schedule app refresh task \(error.localizedDescription)")
      }
  }*/
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  /*    Logger.shared.info("App did enter background")
      if #available(iOS 13, *) {
          self.scheduleAppRefresh()
          self.scheduleBackgroundProcessing()
      }*/
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  

  
  
}


