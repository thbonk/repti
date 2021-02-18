//
//  SpeciesEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 04.01.21.
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

struct SpeciesEditorView: View {

  // MARK: - Public Enums

  enum Mode {
    case create
    case edit
  }

  // MARK: - Public Proeprties

  var mode: Mode

  @State
  var model: SpeciesDAO = SpeciesDAO()

  @Environment(\.presentationMode) var presentationMode

  var saveAction: ((SpeciesDAO) -> ())? = nil
  var cancelAction: (() -> ())? = nil

  var body: some View {
    VStack {
      Text(
        mode == .create
          ? NSLocalizedString("Add Species", comment: "Label")
          : NSLocalizedString("Edit Species", comment: "Label")
      )
      .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
      .padding(.top, 20)

      if UIDevice.current.userInterfaceIdiom == .phone {
        smallUserInterface()
      } else {
        largeUserInterface()
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
            cancelAction?()
            self.presentationMode.wrappedValue.dismiss()
          },
          label: { Text("Cancel") })
      }
      .padding(.bottom, 20)
    }
  }


  // MARK: - Private Methods

  private func largeUserInterface() -> AnyView {
    return
      AnyView(
        Form {
          LazyVGrid(
            columns: [
              GridItem(alignment: .trailing),
              GridItem(alignment: .leading)],
            spacing: 20) {

            Group {
              Text("Name:").font(.headline)
              TextField("Enter Name", text: $model.name)
            }.padding(.top, 10)

            Group {
              Text("Scientific Name:").font(.headline)
              TextField("Enter Scientific Name", text: $model.scientificName)
            }.padding(.bottom, 10)
          }
        }
      )
  }

  private func smallUserInterface() -> AnyView {
    return
      AnyView(
        Form {
          LazyVGrid(
            columns: [
              GridItem(alignment: .leading)],
            spacing: 20) {

            Group {
              VStack(alignment: .leading) {
                Text("Name:").font(.headline)
                TextField("Enter Name", text: $model.name)
              }
            }.padding(.top, 10)

            Group {
              VStack(alignment: .leading) {
                Text("Scientific Name:").font(.headline)
                TextField("Enter Scientific Name", text: $model.scientificName)
              }
            }.padding(.bottom, 10)
          }
        }
      )
  }
}

struct SpeciesEditorView_Previews: PreviewProvider {
  static var previews: some View {
    SpeciesEditorView(mode: .create, model: SpeciesDAO())
  }
}
