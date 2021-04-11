//
//  SpeciesListView.swift
//  Repti
//
//  Created by Thomas Bonk on 08.04.21.
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
        NavigationLink(destination: IndividualsListView(species: spcs)) {
          SpeciesRowView(parent: self, species: spcs)
        }
        .isDetailLink(true)
      }
      .onDelete(perform: deleteItems)
    }
    .listStyle(PlainListStyle())
    .navigationBarTitle(LocalizedStringKey("Species"))
    .navigationBarTitleDisplayMode(.inline)
    .toolbar { toolbar() }
    .environment(\.editMode, self.$editMode)
    .sheet(isPresented: $showSpeciesEditor) {
      SpeciesEditorView(
        species: editSpecies.value!.dao,
           mode: editSpecies.value!.mode,
         onSave: save(species:)) {

        editSpecies.value = nil
      }
    }
  }


  // MARK: - Private Properties

  @Environment(\.managedObjectContext)
  private var viewContext

  @State
  private var editMode: EditMode = .inactive

  @State
  private var showSpeciesEditor = false

  @State
  private var editSpecies = OptionalValue<(species: Species?, dao: SpeciesDAO, mode: SpeciesEditorView.Mode)>()

  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Species.name, ascending: true)], animation: .default)
  private var species: FetchedResults<Species>


  // MARK: - Public Method

  public func edit(species: Species) {
    editSpecies.value = (species: species, dao: species.dao, mode: .edit)
    showSpeciesEditor = true
  }


  // MARK: - Private Methods: Edit

  private func deleteItems(offsets: IndexSet) {
    withAnimation(.easeOut) {
      offsets.map {
        species[$0]
      }.forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        errorAlert(
          message: "Error while deleting a species.",
          error: error)
      }
    }
  }

  private func save(species: SpeciesDAO) throws {
    let spcs = editSpecies.value?.species ?? Species.create(in: viewContext)

    spcs.name = species.name
    spcs.scientificName = species.scientificName
    spcs.individuals = species.individuals

    try viewContext.save()

    editSpecies.value = nil
  }


  // MARK: - Private Methods: UI

  private func toolbar() -> some View {
    return
      HStack {
        EditButton()

        Button {
          editSpecies.value = (species: nil, dao: SpeciesDAO(), mode: .create)
          showSpeciesEditor = true
        } label: {
          Text(LocalizedStringKey("Add"))
        }
      }
  }
}


// MARK: - Preview

struct SpeciesListView_Previews: PreviewProvider {
  static var previews: some View {
    SpeciesListView()
  }
}
