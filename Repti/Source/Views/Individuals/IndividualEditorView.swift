//
//  IndividualEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 02.11.21.
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

  // MARK: - Public Type Aliases

  public typealias SaveCallback = (String) throws -> Void
  public typealias CancelCallback = () throws -> Void


  // MARK: - Public Properties

  var body: some View {
    VStack {
      Text("Individuum erstellen")
        .font(.title)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)

      VStack {
        TextField("Name", text: $name)
      }

      HStack {
        Button(action: save, label: { Text("Sichern").padding(.all, 5) })
        Spacer()
        Button(action: cancel, label: { Text("Abbrechen").padding(.all, 5) })
      }
      .padding(.top, 30)
    }
    .padding(30)
  }

  var onSave: SaveCallback? = nil
  var onCancel: CancelCallback? = nil


  // MARK: - Private Properties

  @Environment(\.presentationMode)
  var presentationMode

  @State
  private var name: String = ""


  // MARK: - Private Methods

  private func save() {
    do {
      try onSave?(name)
      presentationMode.wrappedValue.dismiss()
    } catch {
      errorAlert(
        message: "Fehler beim Speichern des Individuums.",
        error: error)
    }
  }

  private func cancel() {
    DispatchQueue.main.async {
      do {
        try onCancel?()
      } catch {
        errorAlert(
          message: "Fehler beim Verwefen der Änderungen.",
          error: error)
      }
    }

    presentationMode.wrappedValue.dismiss()
  }
}

