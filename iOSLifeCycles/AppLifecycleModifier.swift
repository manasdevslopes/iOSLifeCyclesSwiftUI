//
// AppLifecycleModifier.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 11/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
    

import SwiftUI

enum AppLifecycleEvent {
  case didEnterBackground
  case didBecomeActive
}

struct AppLifecycleModifier: ViewModifier {
  let onChange: (AppLifecycleEvent) -> ()
  
  func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
        onChange(.didBecomeActive)
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
        onChange(.didEnterBackground)
      }
  }
}

extension View {
  func onAppLifecycleChange(_ onChange: @escaping (AppLifecycleEvent) -> ()) -> some View {
    self.modifier(AppLifecycleModifier(onChange: onChange))
  }
}
