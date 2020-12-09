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
        AppDelegate
          .fatalError(
            message: NSLocalizedString("Error while opening database", comment: "Error Message"),
              error: nserror)
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
