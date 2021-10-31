//
//  ReptiApp.swift
//  Repti
//
//  Created by Thomas Bonk on 31.10.21.
//

import SwiftUI

@main
struct ReptiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
