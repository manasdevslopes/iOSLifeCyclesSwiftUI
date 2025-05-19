//
// NotificationHandler.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 11/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
    

import SwiftUI

extension Notification.Name {
  static let remoteCharging = Notification.Name("remoteCharging")
  static let notificationTapped = Notification.Name("notificationTapped")
  static let blockingFeeReceived = Notification.Name("blockingFeeReceived")
  static let blockingFeeTapped = Notification.Name("blockingFeeTapped")
}

class NotificationHandler {
  // Singleton
  static let shared = NotificationHandler()
  private init() {}
  private var hasProcessedNotification: Bool = false
  private var activeView: String?
  
  func setActiveView(_ viewName: String?) {
    activeView = viewName
  }
  
  func getActiveView() -> String? {
    return activeView
  }
}

// MARK: - Foreground Notification Handling
extension NotificationHandler {
  func handleForegroundNotification(userInfo: [AnyHashable: Any]) {
    guard !hasProcessedNotification else { return }
    
    if isLiveSessionFinished(userInfo: userInfo) {
      // Set the flag and post the notification
      hasProcessedNotification = true
      UserDefaults.standard.set(userInfo, forKey: "isLiveSessionFinished")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationCenter.default.post(name: .remoteCharging, object: nil, userInfo: [:])
      }
    } else if isBlockingFee(userInfo: userInfo) {
      // Set the flag and post the notification
      hasProcessedNotification = true
      UserDefaults.standard.set(userInfo, forKey: "isBlockingFee")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationCenter.default.post(name: .blockingFeeReceived, object: nil, userInfo: userInfo)
      }
    }
  }
}

// MARK: - Background (Tapped) Notification Handling
extension NotificationHandler {
  func handleTappedNotification(userInfo: [AnyHashable: Any]) {
    if isLiveSessionFinished(userInfo: userInfo) {
      UserDefaults.standard.set(userInfo, forKey: "isLiveSessionFinished")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationCenter.default.post(name: .notificationTapped, object: nil, userInfo: [:])
      }
    } else if isBlockingFee(userInfo: userInfo) {
      UserDefaults.standard.set(userInfo, forKey: "isBlockingFee")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        NotificationCenter.default.post(name: .blockingFeeTapped, object: nil, userInfo: userInfo)
      }
    }
  }
}

// MARK: - Reset State
extension NotificationHandler {
  func resetNotificationState() {
    hasProcessedNotification = false
  }
}

// MARK: - Private Helpers
extension NotificationHandler {
  private func isLiveSessionFinished(userInfo: [AnyHashable: Any]) -> Bool {
    guard let bodyLocKey = userInfo["body_loc_key"] as? String, bodyLocKey == "LIVE_SESSION",
          let status = userInfo["status"] as? String, status == "FINISHED" else { return false }
    return true
  }
  
  private func isBlockingFee(userInfo: [AnyHashable: Any]) -> Bool {
    guard let bodyLocKey = userInfo["body_loc_key"] as? String, bodyLocKey == "BLOCKING_FEE" else { return false }
    return true
  }
}
