//
// SceneDelegate.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 03/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
    
/*
 In SwiftUI lifecycle apps (introduced in iOS 14 with the @main App structure), the SceneDelegate is not used — it belongs to the UIKit app lifecycle, not the SwiftUI one.
 
 🔄 TL;DR
 If you're using @main struct MyApp: App, you cannot use SceneDelegate directly — SwiftUI doesn't support SceneDelegate in this structure.
 
 To include a SceneDelegate in a SwiftUI app, you have to start with a UIKit lifecycle project, which includes:
 
 AppDelegate
 SceneDelegate
 Then embed SwiftUI in a UIHostingController
 */

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  // Called when the scene is created and connected to the app
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    print("🔵 SceneDelegate: Scene is being connected (willConnectTo)")
    
    // SwiftUI entry point
    let contentView = ContentView()
    
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }
  
  // Called as the scene transitions from background to foreground
  func sceneWillEnterForeground(_ scene: UIScene) {
    print("🌅 SceneDelegate: Scene will enter foreground (sceneWillEnterForeground)")
  }
  
  // Called when the scene becomes active (foreground, receiving input)
  func sceneDidBecomeActive(_ scene: UIScene) {
    print("🟢 SceneDelegate: Scene became active (sceneDidBecomeActive)")
  }
  
  // Called when the scene is about to move from active to inactive (e.g., incoming call)
  func sceneWillResignActive(_ scene: UIScene) {
    print("🟡 SceneDelegate: Scene will resign active (sceneWillResignActive)")
  }
  
  // Called as the scene transitions from foreground to background
  func sceneDidEnterBackground(_ scene: UIScene) {
    print("🌆 SceneDelegate: Scene entered background (sceneDidEnterBackground)")
  }
  
  // Called when the scene is released by the system (usually when backgrounded or closed)
  func sceneDidDisconnect(_ scene: UIScene) {
    print("⚫️ SceneDelegate: Scene was disconnected (sceneDidDisconnect)")
  }
}
