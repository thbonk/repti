//
//  SpeciesEditorView.swift
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

struct SpeciesEditorView: View {

  // MARK: - Public Typealiases

  public typealias OnSaveCallback = (SpeciesDAO) throws -> ()
  public typealias OnCancelCallback = () -> ()


  // MARK: - Public Enums

  public enum Mode {
    case create
    case edit
  }


  // MARK: - Public Properties

  @State
  public var species: SpeciesDAO

  public var mode: Mode = .create

  public var onSave: OnSaveCallback?
  public var onCancel: OnCancelCallback?

  public var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Species Name")) {
          TextField(LocalizedStringKey("Enter name of species"), text: $species.name)
        }
        Section(header: Text("Scientific Name")) {
          TextField(LocalizedStringKey("Enter scientific name of species"), text: $species.scientificName)
        }

        Section {
          HStack {
            Button {
              do {
                try onSave?(species)
                presentationMode.wrappedValue.dismiss()
              } catch {
                errorAlert(
                  message: "Error while saving a species.",
                  error: error)
              }
            } label: {
              Text(LocalizedStringKey("Save"))
                .padding(.all, 5)
            }
            Spacer()
            Button {
              DispatchQueue.main.async {
                onCancel?()
              }
              presentationMode.wrappedValue.dismiss()
            } label: {
              Text(LocalizedStringKey("Cancel"))
                .padding(.all, 5)
            }
          }
        }
      }
      .navigationBarTitle(mode == .create ? LocalizedStringKey("Add Species") : LocalizedStringKey("Edit Species"))
      .navigationBarTitleDisplayMode(.inline)
    }
  }


  // MARK: - Private Properties

  @Environment(\.presentationMode)
  var presentationMode
}

struct SpeciesEditorView_Previews: PreviewProvider {
  static var previews: some View {
    SpeciesEditorView(species: Species().dao)
  }
}
