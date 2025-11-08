//
// StorePushToken.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 19/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
//
// Or do it this way
/*
import FirebaseMessaging
import UIKit
import SwiftUI
import UserNotifications

@MainActor
func storePushToken() async -> Bool {
  guard let _ = GeneralViewModel.shared.user else { return false }
  
  // Request notification permission if not already granted
  let notificationCenter = UNUserNotificationCenter.current()
  let settings = await notificationCenter.notificationSettings()
  
  switch settings.authorizationStatus {
    case .authorized, .provisional, .ephemeral:
      // Notifications allowed -> fetch real token
      do {
        let token = try await Messaging.messaging().token()
        guard !token.isEmpty else { return false }
        
        GeneralViewModel.shared.firebaseToken = token
        dump(token, name: "fcm_token")
        
        // Send token to backend
        Task.detached {
            await UserRepository().storePushNotificationToken(registrationId: token, isActive: true)
        }
 
        return false // Notifications are enabled
      } catch {
        print("Error fetching FCM Token: \(error)")
        return false
      }
      
    case .denied:
      print("Notifications denied. FCM token unavailable.")
      return true
    case .notDetermined:
      // Request authorization
      let granted = try? await notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) {
        if granted == true {
          // Recheck after Permission
          return await storePushToken()
        } else {
          return true // denied
        }
      }
    @unknown default: return false
  }
}
*/
/*
 Then call this function when user logged in / Registered for the first time.
 .onChange(of: generalViewModel.isUserLoggedIn) { newValue in
 if newValue {
 Task {
 _ = await storePushToken()
 }
 }
 }
 
 And also call this in MainView where we have used scenePhase for active, background states of the app.
 */
