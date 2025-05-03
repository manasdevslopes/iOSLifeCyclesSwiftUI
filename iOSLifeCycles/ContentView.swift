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
  }
}

#Preview {
  ContentView()
}
