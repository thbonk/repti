//
//  IndividualEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 06.01.21.
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

struct IndividualEditorView: View {

  // MARK: - Private Properties

  @State
  private var model: IndividualDAO = IndividualDAO(species: Species())
  @State
  private var gender = 2
  @Environment(\.presentationMode)
  private var presentationMode
  private var saveAction: ((IndividualDAO) -> ())? = nil


  // MARK: - Public Properties

  var body: some View {
    VStack {
      Text("Add Individual")
        .font(.title)
        .padding(.top, 20)

      Form {
        LazyVGrid(
          columns: [
            GridItem(alignment: .trailing),
            GridItem(alignment: .leading)],
          spacing: 20) {

          Group {
            Text("Name:")
            TextField("Enter Name", text: $model.name)
          }.padding(.top, 10)
        }
      }

      HStack {
        Button(
          action: {
            saveAction?(model)
            self.presentationMode.wrappedValue.dismiss()
          },
          label: { Text("Save") })
        Button(
          action: {
            self.presentationMode.wrappedValue.dismiss()
          },
          label: { Text("Cancel") })
      }
      .padding(.bottom, 20)
    }
  }


  // MARK: - Initialization

  init(species: Species, saveAction: ((IndividualDAO) -> ())? = nil) {
    self.model.species = species
    self.saveAction = saveAction
  }
}

struct IndividualEditorView_Previews: PreviewProvider {
  static var previews: some View {
    Text("IndividualEditorView")
    //IndividualEditorView()
  }
}
