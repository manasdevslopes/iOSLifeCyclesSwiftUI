//
// iOSLifeCyclesApp.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 03/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//


import SwiftUI

@main
struct iOSLifeCyclesApp: App {
  // Connecting AppDelegate
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @Environment(\.scenePhase) var scenePhase
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .onChange(of: scenePhase) { _, newPhase in
      switch newPhase {
        case .active:
          print("1. Scene is now active: user can interact with the app")
          // Use UNUserNotificationCenter to Remove Delivered Notifications
          UNUserNotificationCenter.current().removeAllDeliveredNotifications()
          // Task { _ = await storePushToken() }
        case .inactive:
          print("2. Scene is inactive: temporary interruption or transitioning")
        case .background:
          print("3. Scene is in background: app no longer visible to the user")
          // Task { _ = await storePushToken() }
        @unknown default:
          print("⚠️ Scene is in an unknown phase: handle with care")
      }
    }
  }
}

/*
 The @Environment(\.scenePhase) property only works in the top-level Scene, such as WindowGroup, DocumentGroup, or App level—not inside arbitrary SwiftUI Views (screens or pages).
 
 ✅ Valid Usage:
 You can only use @Environment(\.scenePhase) inside the view hierarchy that's directly inside your @main App struct's WindowGroup, for example:
 
 
 🚫 Not Valid:
 This will not work inside a view like this:
 
 struct SettingsView: View {
 @Environment(\.scenePhase) private var scenePhase  // ❌ Won't work as expected
 
 var body: some View {
 Text("Settings")
 .onChange(of: scenePhase) { newPhase in
 // This may not be triggered or may behave unpredictably
 }
 }
 }
 
 Best Practice:
 Handle scenePhase at the App level (in the @main App struct).
 Pass down any necessary state or triggers via environment, state, or bindings to lower views (like ContentView, SettingsView, etc.).
 
 */
