//
//  ReptiApp.swift
//  Repti
//
//  Created by Thomas Bonk on 04.01.21.
//  Copyright 2021 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftUI
import FeatureFlagsPackage

@main
struct ReptiApp: App {

  // MARK: - Public Properties
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environment(\.repti_enable_documents, Feature.isEnabled(.repti_enable_documents))
    }
  }


  // MARK: - Initialization

  init() {
    guard let featuresURL = Bundle.main.url(forResource: "features", withExtension: "json") else {
      return
    }

    FeatureFlags.configurationURL = featuresURL
  }
}
