//
//  SpeciesEditorView.swift
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

struct SpeciesEditorView: View {

  // MARK: - Public Type Aliases

  public typealias SaveCallback = (Species) throws -> Void
  public typealias CancelCallback = (Species) throws -> Void

  // MARK: - Public Enums

  public enum Mode {
    case create
    case edit
  }


  // MARK: - Public Properties

  var body: some View {
    VStack {
      Text(editorTitle())
        .font(.title)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)

      VStack {
        TextField("Name der Art", text: $name)
        TextField("Wissenschaftlicher Name", text: $scientificName)
      }

      HStack {
        Button(action: save, label: { Text("Sichern").padding(.all, 5) })
        Spacer()
        Button(action: cancel, label: { Text("Abbrechen").padding(.all, 5) })
      }
      .padding(.top, 30)
    }
    .padding(30)
    .onAppear {
      self.name = self.species.name!
      self.scientificName = self.species.scientificName!
    }
  }


  // MARK: - Initialization

  init(mode: Mode, species: Species, onSave: SaveCallback? = nil, onCancel: CancelCallback? = nil) {
    self.mode = mode
    self.species = species
    self.onSave = onSave
    self.onCancel = onCancel
  }


  // MARK: - Private Properties

  @Environment(\.presentationMode)
  var presentationMode

  @State
  private var name: String = ""
  @State
  private var scientificName: String = ""

  private var mode: Mode
  private var species: Species
  private var onSave: SaveCallback? = nil
  private var onCancel: CancelCallback? = nil


  // MARK: - Private Methods

  private func editorTitle() -> LocalizedStringKey {
    return mode == .edit ? "Art bearbeiten" : "Neue Art erstellen"
  }

  private func save() {
    do {
      species.name = name
      species.scientificName = scientificName
      try onSave?(species)
      presentationMode.wrappedValue.dismiss()
    } catch {
      errorAlert(
        message: "Fehler beim Speichern der Art.",
        error: error)
    }
  }

  private func cancel() {
    DispatchQueue.main.async {
      do {
        try onCancel?(species)
      } catch {
        errorAlert(
          message: "Fehler beim Verwefen der Änderungen.",
          error: error)
      }
    }

    presentationMode.wrappedValue.dismiss()
  }
}

