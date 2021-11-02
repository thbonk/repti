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

import PureSwiftUI

struct SpeciesListView: View {

  // MARK: - Public Properties
  
  var body: some View {
    RenderIf(species.count > 0) {
      List {
        ForEach(species) { spcs in
          NavigationLink(
            destination: IndividualsListView(species: spcs),
            tag: spcs.id!,
            selection: $selectedId) {
              SpeciesRowView(species: spcs)
            }
            .contextMenu {
              Button {
                edit(species: spcs)
              } label: {
                HStack {
                  Image(sfSymbol: .square_and_pencil)
                  Text("Bearbeiten")
                }
              }

              Button {
                delete(species: spcs)
              } label: {
                HStack {
                  Image(sfSymbol: .trash_square)
                  Text("Löschen")
                }
              }
            }
        }
      }
      .listStyle(SidebarListStyle())
    }
    .elseRender {
      Spacer()
      Text("Keine Art gefunden.")
      Spacer()
    }
    .toolbar {
      ToolbarItem(placement: .automatic) {
        Text("Arten")
          .font(.title3)
          .bold()
      }

      ToolbarItem(placement: .automatic) {
        Spacer()
      }

      ToolbarItem(placement: .automatic) {
        Button {
          createSpecies()
        } label: {
          Image(sfSymbol: .plus_app)
        }
      }
    }
    .sheet(isPresented: $showSpeciesEditor) {
      if let edit = editSpecies.value {
        SpeciesEditorView(
          mode: edit.mode,
          species: edit.species,
          onSave: save,
          onCancel: cancel)
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

  @State
  private var showSpeciesEditor = false

  private var editSpecies = ValueWrapper<(species: Species?, mode: SpeciesEditorView.Mode)>()


  // MARK: - Private Methods

  private func createSpecies() {
    editSpecies.value = (species: nil, mode: .create)
    showSpeciesEditor = true
  }

  private func edit(species: Species) {
    editSpecies.value = (species: species, mode: .edit)
    showSpeciesEditor = true
  }

  private func save(_ name: String, _ scientificName: String) throws {
    if editSpecies.value!.mode == .create {
      let species = Species.create(in: viewContext)
      species.name = name
      species.scientificName = scientificName

      selectedId = species.id
    } else {
      editSpecies.value!.species!.name = name
      editSpecies.value!.species!.scientificName = scientificName
    }

    try viewContext.save()
    editSpecies.value?.species = nil
  }

  private func cancel() throws {
    viewContext.rollback()
    editSpecies.value?.species = nil
  }

  private func delete(species: Species) {
    withAnimation(.easeOut) {
      viewContext.delete(species)

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
