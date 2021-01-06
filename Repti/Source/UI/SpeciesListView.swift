//
//  SpeciesListView.swift
//  Repti
//
//  Created by Thomas Bonk on 05.01.21.
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

import SwiftUI

struct SpeciesListView: View {

  // MARK - Private Properties

  @State
  private var editItem: Species? = nil
  @State
  private var editMode: EditMode = .inactive
  @State
  private var showSpeciesEditor: Bool = false

  @Environment(\.managedObjectContext)
  private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Species.name, ascending: true)],
    animation: .default)
  private var species: FetchedResults<Species>


  // MARK: - Public Properties

  var body: some View {
    List {
      ForEach(species) { spcs in
        NavigationLink(
          destination: IndividualListView(species: spcs).navigationBarTitle(spcs.name, displayMode: .inline)) {
          LazyVGrid(
            columns: [GridItem(alignment: .leading), GridItem(alignment: .trailing)],
            content: {
              VStack(alignment: .leading) {
                Text(spcs.name)
                  .font(.headline)
                  .padding(.bottom, 5)
                Text(spcs.scientificName)
                  .font(.subheadline)
              }
            })
            .padding(.all, 10)
        }
        .isDetailLink(false)
        .allowsHitTesting(self.editMode == .inactive ? false : true)
        .onTapGesture(perform: {
          DispatchQueue.main.async {
            editItem = spcs
          }
          DispatchQueue.main.async {
            showSpeciesEditor = true
          }
        })
      }
      .onDelete(perform: deleteItems)
    }
    .navigationTitle(Text("Species"))
    .navigationBarItems(
      leading: Spacer(),
      trailing: HStack {
        EditButton()

        Button(action: { showSpeciesEditor = true }) {
          Image(systemName: "plus")
        }
        .sheet(isPresented: $showSpeciesEditor, content: {
          if editMode == .active {
            SpeciesEditorView(mode: .edit, model: SpeciesDAO(species: editItem), saveAction: self.saveChanged(species:))
          } else {
            SpeciesEditorView(mode: .create, saveAction: self.saveNew(species:))
          }
        })
      })
    .environment(\.editMode, self.$editMode)
  }


  // MARK: - Private Methods

  private func saveChanged(species: SpeciesDAO) {
    do {
      editItem?.name = species.name
      editItem?.scientificName = species.scientificName

      try viewContext.save()

      editItem = nil
    } catch {
      errorAlert(
        message: NSLocalizedString("Error while saving changed species.", comment: "Error Message"),
        error: error)
    }
  }

  private func saveNew(species: SpeciesDAO) {
    withAnimation {
      let newSpecies = Species.create(in: viewContext)

      newSpecies.name = species.name
      newSpecies.scientificName = species.scientificName

      do {
        try viewContext.save()
      } catch {
        errorAlert(
          message: NSLocalizedString("Error while saving a new species.", comment: "Error Message"),
          error: error)
      }
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map {
        species[$0]
      }.forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        errorAlert(
          message: NSLocalizedString("Error while deleting a species.", comment: "Error Message"),
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