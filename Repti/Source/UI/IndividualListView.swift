//
//  IndividualListView.swift
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

struct IndividualListView: View {

  // MARK: - Public Properties

  var species: Species


  // MARK: - Private Properties

  @State
  private var showIndividualEditor = false
  @State
  private var selectedId: UUID? = nil
  @Environment(\.managedObjectContext)
  private var viewContext

  private var individuals: FetchRequest<Individual>

  var body: some View {
    List {
      ForEach(individuals.wrappedValue) { individual in
        NavigationLink(
          destination:
            IndividualDetailView(
              individual:
                Binding<Individual>(
                  get: { return individual },
                  set: { _ in
                    do {
                      try viewContext.save()
                    } catch {
                      errorAlert(message: "Error while saving changes to individual.", error: error)
                    }
                  })),
          tag: individual.id,
          selection: $selectedId) {
          LazyVGrid(
            columns: [GridItem(alignment: .leading), GridItem(alignment: .trailing)],
            content: {
              Text(individual.name)
                .font(.headline)
              Text(individual.gender.displayName)
                .font(.subheadline)
            })
            .padding(.all, 10)
        }
      }
      .onDelete(perform: deleteItems)
    }
    .navigationTitle(Text(species.name))
    .navigationBarItems(trailing: HStack {
      EditButton()
      Button(action: { showIndividualEditor = true }) {
        Image(systemName: "plus")
      }
      .sheet(isPresented: $showIndividualEditor, content: {
        IndividualEditorView(species: self.species, saveAction: self.saveNew(individual:))
      })
    })
  }


  // MARK: - Initialization

  init(species: Species) {
    self.species = species
    individuals =
      FetchRequest(
        entity: Individual.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Individual.name, ascending: true)],
        predicate: NSPredicate(format: "species.id = %@", argumentArray: [species.id]), //NSPredicate(format: "species.id = %@", species.id),
        animation: .default)
  }


  // MARK: - Private Methods

  private func genderSign(_ gender: Gender) -> String {
    switch gender {
    case .female:
      return "♀️"

    case .male:
      return "♂️"

    default:
      return "?"
    }
  }

  private func saveNew(individual: IndividualDAO) {
    withAnimation {
      let newIndividual = Individual.create(in: viewContext)

      newIndividual.name = individual.name
      newIndividual.species = species
      species.addToIndividuals(newIndividual)

      do {
        try viewContext.save()

        selectedId = newIndividual.id
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
        individuals.wrappedValue[$0]
      }.forEach(viewContext.delete)

      do {
        try viewContext.save()
      } catch {
        errorAlert(
          message: NSLocalizedString("Error while deleting an individual.", comment: "Error Message"),
            error: error)
      }
    }
  }
}

struct IndividualListView_Previews: PreviewProvider {
  static var previews: some View {
    Text("Individuals")
    //IndividualListView()
  }
}
