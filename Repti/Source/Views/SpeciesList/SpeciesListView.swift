//
//  SpeciesListView.swift
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

import SwiftUI

struct SpeciesListView: View {

  // MARK: - Public Properties
  
  var body: some View {
    List {
      ForEach(species, id: \.id) { spcs in
        NavigationLink(
          destination: Text(spcs.name!),
          tag: spcs.id!,
          selection: $selectedId) {
            SpeciesRowView(species: spcs, edit: { edit(species: spcs) })
          }
      }
      .onDelete(perform: deleteSpecies)
    }
    .listStyle(SidebarListStyle())
    .toolbar {
      ToolbarItem(placement: .automatic) {
        Text("Arten")
          .font(.title)
      }

      ToolbarItem(placement: .automatic) {
        Spacer()
      }

      ToolbarItem(placement: .automatic) {
        Button {

        } label: {
          Image(systemName: "plus.app")
        }
      }
    }
  }


  // MARK: - Private Properties

  @Environment(\.managedObjectContext)
  private var viewContext

  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Species.name, ascending: true)], animation: .default)
  private var species: FetchedResults<Species>

  @State
  private var selectedId: UUID!


  // MARK: - Private Methods

  private func edit(species: Species) {

  }

  private func deleteSpecies(offsets: IndexSet) {
    withAnimation(.easeOut) {
      offsets.map {
        species[$0]
      }
      .forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        errorAlert(
          message: "Fehler beim Löschen der Art.",
          error: error)
      }
    }
  }
}

struct SpeciesListView_Previews: PreviewProvider {
  static var previews: some View {
    SpeciesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
