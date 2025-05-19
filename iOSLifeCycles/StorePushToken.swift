//
// StorePushToken.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 19/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
// Or do it this way
// import FirebaseMessaging
//import Foundation
//
//func storePushToken() async {
//  guard let _ GeneralViewModel.shared.user else { return }
//  
//  // Request notification permission if not already granted
//  let notificationCenter = UNUserNotificationCenter.current()
//  let settings = await notificationCenter.notificationSettings()
//  if settings.authorizationStatus != .authorized {
//    let granted = (try? await notificationCenter.requestAuthorization(options: [.sound, .alert, .badge])) ?? false
//    if !granted { return }
//  }
//  
//  do {
//    // Always Fetch the most current token from Firebase
//    let token = try await Messaging.messaging().token()
//    guard !token.isEmpty else { return }
//    GeneralViewModel.shared.firebaseToken = token
//    
//    // Send token to backend
//    await UserRepository().storePushNotificationToken(registrationId: token, isActive: true)
//  } catch {
//    print("Error fetching FCM token: \(error)")
//  }
//}

/*
 Then call this function when user logged in / Registered for the first time.
 .onChange(of: generalViewModel.isUserLoggedIn) { newValue in
 if newValue {
 Task {
 await storePushToken()
 }
 }
 }
 
 And also call this in MainView where we have used scenePhase for active, background states of the app.
 */
