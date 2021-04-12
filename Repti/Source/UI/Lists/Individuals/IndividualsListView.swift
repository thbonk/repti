//
//  IndividualsListView.swift
//  Repti
//
//  Created by Thomas Bonk on 10.04.21.
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

  public var species: Species

  public var body: some View {
    RenderIf(individuals.wrappedValue.isNotEmpty) {
      List {
        ForEach(individuals.wrappedValue, id: \.self) { individual in
          IndividualRowView(individual: individual)
            .padding(.vertical, 10)
        }
        .onDelete(perform: deleteItems)
      }
      .listStyle(PlainListStyle())
    }.elseRender {
      Text(LocalizedStringKey("No \(species.name) found."))
    }
    .navigationBarTitle(species.name)
    .navigationBarItems(leading: leadingBarItems(), trailing: trailingBarItems())
    .navigationBarTitleDisplayMode(.inline)
    .environment(\.editMode, self.$editMode)
  }


  // MARK: - Private Properties

  @Environment(\.managedObjectContext)
  private var viewContext

  @State
  private var showIndividualEditor = false

  @State
  private var editMode: EditMode = .inactive

  @State
  private var selectedId: UUID? = nil

  private var individuals: FetchRequest<Individual>


  // MARK: - Initialization
  
  init(species spcs: Species) {
    self.species = spcs
    self.individuals =
      FetchRequest(
        entity: Individual.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Individual.name, ascending: true)],
        predicate: NSPredicate(format: "species.id = %@", argumentArray: [spcs.id!]),
        animation: .default)
  }


  // MARK: - Private methods

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

  private func leadingBarItems() -> some View {
    return HStack(alignment: .center) {
      EditButton()
    }
  }

  private func trailingBarItems() -> some View {
    return HStack(alignment: .center) {
      Button {
        showIndividualEditor = true
      } label: {
        Text(LocalizedStringKey("Add"))
      }
    }
  }
}

struct IndividualsListView_Previews: PreviewProvider {
  static var previews: some View {
    IndividualsListView(species: Species())
  }
}
