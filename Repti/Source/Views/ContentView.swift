//
//  ContentView.swift
//  Repti
//
//  Created by Thomas Bonk on 31.10.21.
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
import PureSwiftUI

struct ContentView: View {

  // MARK: - Public Properties

  var body: some View {
    NavigationView {
      SpeciesListView()
      EmptyView()
      EmptyView()
    }
    .sheet(
      isPresented: $showAlert,
      onDismiss: {
        data.value?.dismissCallback()
      }, content: {
        AlertContentView(
          alertType: data.value?.type ?? .information,
            message: data.value?.message ?? "",
              error: data.value?.error)
      })
    .onAppear(perform: registerForToastNotification)
    .onDisappear(perform: deregisterFromToastNotification)
  }

  init() {
    showAlert = false
  }


  // MARK: - Private Properties

  @State
  private var showAlert: Bool

  //@State
  private var data: ValueWrapper<AlertData> = ValueWrapper()

  @State
  private var observer: NSObject!


  // MARK: - Private Methods

  private func registerForToastNotification() {
    observer =
      NotificationCenter
        .default
        .addObserver(
          forName: .showAlert,
           object: nil,
            queue: OperationQueue.main,
            using: showToast(notification:)) as? NSObject
  }

  private func deregisterFromToastNotification() {
    NotificationCenter.default.removeObserver(observer as Any)
  }

  private func showToast(notification: Notification) {
    self.data.value = notification.alertData
    self.showAlert = true
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

/*
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
*/
