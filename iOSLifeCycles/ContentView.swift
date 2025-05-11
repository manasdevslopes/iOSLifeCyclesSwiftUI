//
// ContentView.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 03/05/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//


import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Lifecycle Demo")
        .font(.largeTitle)
        .padding()
      Text("Check the Xcode console for lifecycle logs.")
        .font(.subheadline)
    }
    .onAppear {
      print("ContentView: onAppear")
    }
    .onDisappear {
      print("ContentView: onDisappear")
    }
    /* Or, create a modifer for this
     .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
      // Do SOmething
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
      // Do SOmething
    }
    */
    /* If you want to run the same code regardless of the event */
    .onAppLifecycleChange { _ in
      print("App lifecycle changed — do something")
    }
    /* Or, like this below: */
    .onAppLifecycleChange { event in
      switch event {
        case .didEnterBackground:
          print("Do something when app goes to background")
        case .didBecomeActive:
          print("Do something when app becomes active")
      }
    }
  }
}

#Preview {
  ContentView()
}
