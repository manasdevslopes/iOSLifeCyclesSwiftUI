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
  
  // MARK: - Maintenance Silent Notification Observer
  static let maintenance = Notification.Name("maintenanceSilent")
}

class NotificationHandler {
  // Singleton
  static let shared = NotificationHandler()
  private init() {}
  private var hasProcessedNotification: Bool = false
  private var activeView: String?
  private var dispatchTime: DispatchTime = .now() + 1
  
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
      liveSession(userInfo: userInfo, .remoteCharging)
      return
    }
    
    if isBlockingFee(userInfo: userInfo) {
      // Set the flag and post the notification
      hasProcessedNotification = true
      blockingFee(userInfo: userInfo, .blockingFeeReceived)
      return
    }
    
    if isMaintenanceSilent(userInfo: userInfo) {
      // Set the flag and post the notification
      hasProcessedNotification = true
      maintenanceSilent(userInfo: userInfo, .maintenance)
      return
    }
  }
}

// MARK: - Background (Tapped) Notification Handling
extension NotificationHandler {
  func handleTappedNotification(userInfo: [AnyHashable: Any]) {
    if isLiveSessionFinished(userInfo: userInfo) {
      liveSession(userInfo: userInfo, .notificationTapped)
      return
    }
    
    if isBlockingFee(userInfo: userInfo) {
      blockingFee(userInfo: userInfo, .blockingFeeTapped)
      return
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
  
  private func isMaintenanceSilent(userInfo: [AnyHashable: Any]) -> Bool {
    guard let aps = userInfo["aps"] as? [String: Any], let contentAvailable = aps["content-available"] as? Int, contentAvailable == 1 else { return false }
    return true
  }
}

extension NotificationHandler {
  private func liveSession(userInfo: [AnyHashable: Any], _ name: Notification.Name) {
    UserDefaults.standard.set(userInfo, forKey: "isLiveSessionFinished")
    DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
      NotificationCenter.default.post(name: name, object: nil, userInfo: [:])
    }
  }
  
  private func blockingFee(userInfo: [AnyHashable: Any], _ name: Notification.Name) {
    UserDefaults.standard.set(userInfo, forKey: "isBlockingFee")
    DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
      NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
  }
  
  private func maintenanceSilent(userInfo: [AnyHashable: Any], _ name: Notification.Name) {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
  }
}
