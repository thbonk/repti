//
//  Persistence.swift
//  Repti
//
//  Created by Thomas Bonk on 04.01.21.
//
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

import CoreData

/**
 Custom notifications in this sample.
 */
extension Notification.Name {
  static let didFindRelevantTransactions = Notification.Name("didFindRelevantTransactions")
}

class PersistenceController {
  static let appTransactionAuthorName = "Repti"
  static let shared = PersistenceController()

  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for i in 0..<10 {
      let species = Species.create(in: viewContext)
      species.name = "Name \(i)"
      species.scientificName = "Scientific Name \(i)"
    }
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()

  let container: NSPersistentCloudKitContainer

  /**
   An operation queue for handling history processing tasks: watching changes, deduplicating tags, and triggering UI updates if needed.
   */
  private lazy var historyQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  /**
   Track the last history token processed for a store, and write its value to file.

   The historyQueue reads the token when executing operations, and updates it after processing is complete.
   */
  private var lastHistoryToken: NSPersistentHistoryToken? = nil {
    didSet {
      guard let token = lastHistoryToken,
            let data = try? NSKeyedArchiver.archivedData( withRootObject: token, requiringSecureCoding: true) else { return }

      do {
        try data.write(to: tokenFile)
      } catch {
        print("###\(#function): Failed to write token data. Error = \(error)")
      }
    }
  }

  /**
   The file URL for persisting the persistent history token.
   */
  private lazy var tokenFile: URL = {
    let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("Repti", isDirectory: true)
    if !FileManager.default.fileExists(atPath: url.path) {
      do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
      } catch {
        print("###\(#function): Failed to create persistent container URL. Error = \(error)")
      }
    }
    return url.appendingPathComponent("token.data", isDirectory: false)
  }()

  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Repti")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }

    // Enable history tracking and remote notifications
    guard let description = container.persistentStoreDescriptions.first else {
      fatalError("###\(#function): Failed to retrieve a persistent store description.")
    }
    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalErrorAlert(message: NSLocalizedString("Unresolved error", comment: "Error Message"), error: error)
      }
    })

    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.transactionAuthor = PersistenceController.appTransactionAuthorName

    // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes.
    container.viewContext.automaticallyMergesChangesFromParent = true
    do {
      try container.viewContext.setQueryGenerationFrom(.current)
    } catch {
      fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
    }

    // Observe Core Data remote change notifications.
    NotificationCenter.default.addObserver(
      self, selector: #selector(type(of: self).storeRemoteChange(_:)),
      name: .NSPersistentStoreRemoteChange, object: container)
  }


  // MARK: - Private Methods

  /**
   Handle remote store change notifications (.NSPersistentStoreRemoteChange).
   */
  @objc func storeRemoteChange(_ notification: Notification) {
    print("###\(#function): Merging changes from the other persistent store coordinator.")

    // Process persistent history to merge changes from other coordinators.
    historyQueue.addOperation {
      self.processPersistentHistory()
    }
  }

  /**
   Process persistent history, posting any relevant transactions to the current view.
   */
  func processPersistentHistory() {
    let taskContext = container.newBackgroundContext()
    taskContext.performAndWait {

      // Fetch history received from outside the app since the last token
      let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
      historyFetchRequest.predicate =
        NSPredicate(format: "author != %@", PersistenceController.appTransactionAuthorName)
      let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
      request.fetchRequest = historyFetchRequest

      let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
      guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
            !transactions.isEmpty
      else { return }

      // Post transactions relevant to the current view.
      DispatchQueue.main.async {
        NotificationCenter
          .default
          .post(name: .didFindRelevantTransactions, object: self, userInfo: ["transactions": transactions])
      }

      // Update the history token using the last transaction.
      lastHistoryToken = transactions.last!.token
    }
  }
}
