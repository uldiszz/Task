//
//  AppDelegate.swift
//  Task
//
//  Created by Uldis Zingis on 05/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    func saveContext () {
        TaskController.sharedController.save()
    }

}

