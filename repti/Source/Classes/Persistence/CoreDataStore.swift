/*
 Copyright 2020 Thomas Bonk <thomas@meandmymac.de>

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import CoreData

class CoreDataStore {

  // MARK: - Public Variables

  private(set) var persistentContainer: NSPersistentContainer


  // MARK: - Initialization

  init(inMemory: Bool = false) {
    persistentContainer = NSPersistentContainer(name: "repti")

    if inMemory {
      let description = NSPersistentStoreDescription()

      description.url = URL(fileURLWithPath: "/dev/null")
      persistentContainer.persistentStoreDescriptions = [description]
    }

    persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let nserror = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    })
  }


  // MARK: - Core Data Saving support

  func saveContext() throws {
    let context = persistentContainer.viewContext

    if context.hasChanges {
      try context.save()
    }
  }

  func rollbackContext() {
    let context = persistentContainer.viewContext

    if context.hasChanges {
      context.rollback()
    }
  }

}
