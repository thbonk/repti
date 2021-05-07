//
//  RootView.swift
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

struct RootView: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    NavigationView {
      SpeciesListView()
      EmptyView()
      EmptyView()
    }.onAppear {
      let controller = UIApplication.shared.windows.first { $0.isKeyWindow }!.rootViewController

      guard let split = controller?.children[0] as? UISplitViewController else {
        NSLog("\(String(describing: controller?.children[0])) is not a split view")
        return
      }
      split.preferredDisplayMode = .twoBesideSecondary
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
