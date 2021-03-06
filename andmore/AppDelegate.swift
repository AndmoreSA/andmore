//
//  AppDelegate.swift
//  andmore
//
//  Created by Abdulrahman Alnajdi on 10/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        attemptToRegisterForNotifications(application: application)
        return true
    }
    
    func attemptToRegisterForNotifications(application: UIApplication) {
        
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        // iOS 10 Support
        if #available(iOS 11, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.alert,.sound]) { (granted, error) in
            }
            application.registerForRemoteNotifications()
        }else {
            let notificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEBUG: Registerd for Notifications with device Token:",deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("DEBUG: Registed with FCM Token:",fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
