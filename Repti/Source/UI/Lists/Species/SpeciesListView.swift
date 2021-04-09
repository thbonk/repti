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
    List(species, id: \.id) { spcs in
      NavigationLink(destination: EmptyView()) {
        SpeciesRowView(parent: self, species: spcs)
      }
      .isDetailLink(true)
    }
    .listStyle(PlainListStyle())
    .navigationBarTitle(LocalizedStringKey("Species"))
    .navigationBarTitleDisplayMode(.inline)
    .toolbar(content: toolbar)
    .environment(\.editMode, self.$editMode)
  }


  // MARK: - Private Properties

  @State
  private var editMode: EditMode = .inactive

  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Species.name, ascending: true)], animation: .default)
  private var species: FetchedResults<Species>


  // MARK: - Public Method

  public func edit(species: Species) {
    
  }


  // MARK: - Private Methods

  private func toolbar() -> some View {
    return
      HStack {
        Button {
        } label: {
          Image(systemName: "plus.rectangle.fill")
        }

        EditButton()
      }
  }
}


// MARK: - Preview

struct SpeciesListView_Previews: PreviewProvider {
  static var previews: some View {
    SpeciesListView()
  }
}
