//
// AppDelegate.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 03/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
    
import UserNotifications
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("1. App launched: didFinishLaunchingWithOptions")
    
    // Request notification permissions
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("❌ Notification authorization error: \(error.localizedDescription)")
      }
      if granted {
        print("🔔 Notification permission granted: \(granted)")
        // Get token from Firebase and do something witht the token.
      }
    }
    
    // Register with APNs
    application.registerForRemoteNotifications()
    
    // Handle notifications if the app is launched from terminated state
    if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable : Any] {
      print("📢 Received remote notification in didFinishLaunchingWithOptions: \(remoteNotification)")
    }
    
    // Use UNUserNotificationCenter to Remove Delivered Notifications
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    
    return true
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    print("2. App is active and running: applicationDidBecomeActive")
    // Use UNUserNotificationCenter to Remove Delivered Notifications
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    print("3. App will move from active to inactive: applicationWillResignActive")
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    print("4. App moved to background: applicationDidEnterBackground")
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    print("5. App will enter foreground from background: applicationWillEnterForeground")
  }
  
  /* ⚠️ Note: applicationDidBecomeActive(_:) is shown twice — this is intentional, as it gets called after launch and again after returning from the background.
  func applicationDidBecomeActive(_ application: UIApplication) {
    print("App is active again: applicationDidBecomeActive")
  }
  */
  
  func applicationWillTerminate(_ application: UIApplication) {
    print("6. App is about to terminate: applicationWillTerminate")
  }
}


/* All methods of Push Notifications */
extension AppDelegate: UNUserNotificationCenterDelegate {
  // 1. Method is the same as mentioned above - didFinishLaunchingWithOptions
  
  // 2. Handle Device Token (APNs Registration)
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { String(format: "%02.2hhx", $0) }
    let token = tokenParts.joined()
    print("✅ Successfully registered for notifications. Device Token: \(token)")
  }
  
  // 3. If Failed to register
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
    print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
  }
  
  // 4. App receives notification in foreground
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("📬 Notification received in foreground:")
    print("🔹 Title: \(notification.request.content.title)")
    print("🔹 Body: \(notification.request.content.body)")
    
    completionHandler([.banner, .sound, .badge, .list])
    
    /*
     🧠 Common Combinations
     Combination  Effect
     [.banner, .sound]  Shows banner + plays sound, doesn't stay in history
     [.list]  Notification silently added to Notification Center
     [.banner, .sound, .list]  Banner + sound now + saved to Notification Center
     [.badge, .list]  Updates badge and stores in history, no banner/sound
     */
  }
  
  // 5. User tapped or interacted with a notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("📲 User interacted with notification")
    let content = response.notification.request.content
    print("🔹 Title: \(content.title)")
    print("🔹 Body: \(content.body)")
    
    completionHandler()
  }
  
  // 6. handles silent push notifications and background updates in iOS.
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("📦 Received silent push or remote notification")
    print("Payload: \(userInfo)")
    
    // Perform background data sync or processing here
    // ...
    
    completionHandler(.newData) // or .noData or .failed
  }
  /*
   ⚠️ Important Notes
   
   Condition  Effect
   content-available = 1  Enables background delivery
   App must have background mode  ✅ “Background fetch” enabled in capabilities
   No alert/sound in payload (for silent)  Required for silent push
   Call completionHandler  ✅ Required to avoid throttling
   
   ✅ Step 1: Enable Background Modes in Xcode
   
   Open your app's target in Xcode.
   Go to Signing & Capabilities → click + Capability
   Add Background Modes
   Check ✅ Background fetch and ✅ Remote notifications
   
   1. 📁 Add Custom Sound to Your App Bundle
   Use .aiff, .wav, or .caf format (under 30 seconds)
   Drag it into your Xcode project
   Make sure it's included in the app target
   Example filename: alert_sound.caf
   
   2. ✅ Modify Your APNs Payload
   Your remote push payload (JSON) must include the sound key with the exact filename:
   
   3. ✅ AppDelegate Setup (Optional Debug Logging)
   No special Swift code is needed for custom sounds beyond registering for notifications, but you can log incoming pushes: didReceiveRemoteNotification
   */
}

extension AppDelegate {
  // Other methods
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Called when the application is opened from the other app (like a deep link).
    return true
  }
}
