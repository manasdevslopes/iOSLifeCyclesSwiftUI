//
// EnvironmentConf.swift
// iOSLifeCycles
//
// Created by MANAS VIJAYWARGIYA on 18/10/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
    

import Foundation

/*
 - First create a GoogleService-Info.Plist file from Firebase and add it in the project.
 - Second, create a User-Defined Setting in Build Settings same way as we did in Environment Setup blog from bacenova.wordpress.com. Let's say name is FIREBASE_FILENAME and its value is GoogleService-Info.Plist.
 - Third, Also add this FIREBASE_FILENAME in Config files -
 FIREBASE_FILENAME=GoogleService-Info.Plist
 - Fourth, add FIREBASE_FILENAME in Info.plist and its value will be $(FIREBASE_FILENAME)
 - Fifth, Create a EnvironmentConf.swift and add below code -
 */

public enum EnvironmentConf {
  enum Plist {
    static let firebaseFile = "FIREBASE_FILENAME"
  }
  
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    return dict
  }()
  
  static let firebaseFile: String? = {
    guard let file = EnvironmentConf.infoDictionary[Plist.firebaseFile] as? String, !file.isEmpty else {
      return nil
    }
    
    return file
  }()
}

/*
 - Sixth, Now go to App Delegate and add the check and FirebaseApp.configure() code
 */
