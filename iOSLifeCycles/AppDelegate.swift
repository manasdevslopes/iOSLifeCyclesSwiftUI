//
// AppDelegate.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 03/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
// import FirebaseCore
// import FirebaseMessaging // If u want to send fcm token everytime to BE.
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
//      Messaging.messaging().token { token, _ in
//        Get token from Firebase and do something witht the token like this below.
//        if let token { GeneralViewModel.shared.firebaseToken = token }
//      }
      }
    }
    
    if EnvironmentConf.firebaseFile != nil {
      // Register with APNs
      application.registerForRemoteNotifications()
      // FirebaseApp.configure()
    }
    
    // Handle notifications if the app is launched from terminated state
    if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable : Any] {
      UserDefaults.standard.removeObject(forKey: "isBlockingFee")
      print("📢 Received remote notification in didFinishLaunchingWithOptions: \(remoteNotification)")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationHandler.shared.handleForegroundNotification(userInfo: remoteNotification)
      }
    }
    
    // Use UNUserNotificationCenter to Remove Delivered Notifications
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    
    // Messaging.messaging().delegate = self
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
    UserDefaults.standard.removeObject(forKey: "isBlockingFee")
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
    
    // When doing Silent Push Notification then we need to add a key - FirebaseAppDelegateProxyEnabled Key to false in info.plist. By doing this Firebase can't get fcm_token. So directly pass that token from here with the below code.
    // Messagin.messaging().apnsToken = deviceToken
    // Then use this method - didReceiveRemoteNotification to handle silent notifications.
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
    let userInfo = notification.request.content.userInfo
    NotificationHandler.shared.handleForegroundNotification(userInfo: userInfo)
    // Wnen no banner to be shown in all App state then make this completionHandler([]) as empty Array. So all the time Noti will appear only in notification center and in foreground state, it will get only payloads of notif, the UI won;t be shown.
    completionHandler([.banner, .sound, .badge, .list])
    if let bodyLocKey = userInfo["body_loc_key"] as? String, bodyLocKey == "BLOCKING_FEE" {
      completionHandler([.banner])
    } else if let bodyLocKey = userInfo["body_loc_key"] as? String, bodyLocKey == "LIVE_SESSION" {
      completionHandler([])
    }
    
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
    let userInfo = content.userInfo
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      NotificationHandler.shared.handleTappedNotification(userInfo: userInfo)
    }
    completionHandler()
  }
  
  // 6. handles silent push notifications and background updates in iOS.
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("📦 Received silent push or remote notification")
    print("Payload: \(userInfo)")
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted), let jsonString = String(data: jsonData, encoding: .utf8) {
      print("didReceiveRemoteNotification: \(jsonString)")
    }
    
    if let aps = userInfo["aps"] as? [String: Any], let contentAvailable = aps["content-available"] as? Int, contentAvailable == 1 {
      NotificationHandler.shared.handleForegroundNotification(userInfo: userInfo)
     
      completionHandler(.newData)
    } else {
      completionHandler(.noData) // or .noData or .failed
    }
  }
  /*
   When doing Silent Push Notification then we need to add a key - FirebaseAppDelegateProxyEnabled Key to false in info.plist. By doing this Firebase can't get fcm_token. So directly pass that token from here with the below code.
   Messagin.messaging().apnsToken = deviceToken
   Then use this method - didReceiveRemoteNotification to handle silent notifications.
   
   To test the Silent / Push Notification, can use OAuth API by generating OAuth token from here - OAuth 2.0 Playground
   Link - https://developers.google.com/oauthplayground/
   Then here in Step 1 - Select Authorize API from the list -> "Firebase Cloud Messaging API v1" -> Select "https://www.googleapis.com/auth/firebase.messaging" -> Click Authorize API button
   Then it will ask for login with gmail account. Then Login with that. Then select Continue.
   
   Then in Step 2 - Exchange authorization code for tokens -> Click on Exchange authorization code for tokens button.
   
   Then copy the access Token. It might expire in 1 hour, then regenerate the token, if required.
   
   Full POSTMAN cURL or API
   POST -> https://fcm.googleapis.com/v1/projects/project-name-from-firebase/messages:send
   Headers -
   content-type : application/json
   authorization : Bearer <token from OAuth 2.0 Playground>
   
   Body -
   {
     "message": {
        "token": "fcm_token",
        "data": {
          "end_timestamp": "{{$timestamp}}",
          "start_timestamp": "1779803248",
          "is_maintenance" : "true"
        },
        "android": {
           "priority": "high"
        },
        "apns": {
          "payload": {
             "aps": {
               "content-available": 1
             }
          },
          "headers": {
            "apns-priority": "10",
            "apns-push-type": "background"
          }
        }
     }
   }
   
   */
  
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

//extension AppDelegate: MessagingDelegate {
//  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//    guard let token = fcmToken else { return }
//      GeneralViewModel.shared.firebaseToken = token
//  }
//}

// MARK: - PushNotificationPayload.apns file example
/*
 {
 "aps": {
 "content-available": 1,
 "alert": {
 "title": "Hello",
 "body": "This has a custom sound!"
 },
 "sound": "alert_sound.caf",
 "badge": 1
 },
 "customKey": "yourDataHere"
 }
 
 Note -
 ✅ If we use title and body inside alert then it will take those string to show title and body of the push notification.
 ✅ If we use only body and don't use title / title-loc-key then it will show App display name from CFBundleDisplayName in Info.plist as title and prescribed body.
 ✅ If we want those title's and body's to be translated then use this keys with the values of localised.xcstring keys. Check below keys for to write instead of title and body.
    Localized Title - "title-loc-key"
    Title Arguments - "title-loc-args"
    Localized Body - "loc-key"
    Body Arguments - "loc-args"
 ✅ For examples
    "alert": {
       "title-loc-key": "NOTIF_TITLE_SESSION_ENDED_USER",
       "title-loc-args": ["John"],
       "loc-key": "NOTIF_BODY_SESSION_ENDED_USER",
       "loc-args": ["EV Station 4"]
    }
 ✅ Localizable.strings
    "NOTIF_TITLE_SESSION_ENDED_USER" = "Session Ended for %@";
    "NOTIF_BODY_SESSION_ENDED_USER" = "Your charging session at %@ has ended. Please disconnect.";
 */
