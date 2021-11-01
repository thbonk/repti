//
//  SpeciesRowView.swift
//  Repti
//
//  Created by Thomas Bonk on 09.04.21.
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

struct SpeciesRowView: View {

  // MARK: - Public Properties

  var body: some View {
    LazyHGrid(rows: [GridItem(alignment: .leading), GridItem(alignment: .trailing)]) {
      Text(species.name!)
        .font(.headline)
        .padding(.bottom, 5)
      Text(species.scientificName!)
        .font(.subheadline)
    }
    .padding(.all, 10)
    .contextMenu {
      Button {
        edit()
      } label: {
        HStack {
          Image(systemName: "square.and.pencil")
          Text("Bearbeiten")
        }
      }
    }
  }

  var species: Species
  var edit: () -> ()
}

struct SpeciesRowView_Previews: PreviewProvider {
  static var previews: some View {
    SpeciesRowView(species: Species(), edit: {})
  }
}
