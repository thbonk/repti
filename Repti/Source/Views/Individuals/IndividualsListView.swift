//
//  IndividualsListView.swift
//  Repti
//
//  Created by Thomas Bonk on 01.11.21.
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

struct IndividualsListView: View {

  // MARK: - Public Properties

  var body: some View {
    List {
      ForEach(individuals) { individual in
        NavigationLink(
          destination: Text(individual.name!), // TODO
          tag: individual.id!,
          selection: $selectedId) {
            // TODO IndividualRowView(species: spcs, edit: { edit(species: spcs) })
            Text(individual.name!)
          }
          .contextMenu {
            Button {
              // TODO delete(species: spcs)
            } label: {
              HStack {
                Image(sfSymbol: .trash_square)
                Text("Löschen")
              }
            }
          }
      }
    }
    .navigationTitle(Text("\(species.name!) (\(species.scientificName!))"))
    .toolbar {
      ToolbarItem(placement: .automatic) {
        Button {
          
        } label: {
          Image(sfSymbol: .plus_app)
        }
      }
    }
    .onAppear(perform: filterForSpecies)
  }

  var species: Species


  // MARK: - Private Properties

  @Environment(\.managedObjectContext)
  private var viewContext

  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Individual.name, ascending: true)], animation: .default)
  private var individuals: FetchedResults<Individual>

  @State
  private var selectedId: UUID!


  // MARK: - Private Methods

  private func filterForSpecies() {
    individuals.nsPredicate = NSPredicate(format: "species.id == %@", argumentArray: [species.id!])
  }
}

