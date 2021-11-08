//
//  WeightEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 06.11.21.
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

struct WeightEditorView: View {

  // MARK: - Public Typealiases

  typealias SaveCallback = (Date, Float) -> Void
  typealias CancelCallback = () -> Void


  // MARK: - Public Enums

  enum Mode {
    case create
    case edit
  }


  // MARK: - Public Properties

  var body: some View {
    VStack {
      EditorTitle()

      LazyVGrid(columns: [.init(alignment: .trailing), .init(alignment: .leading)]) {
        Text("Datum:")
        DatePicker("", selection: $dateVal, displayedComponents: .date).pickerStyle(MenuPickerStyle())
        Text("Gewicht:")
        TextField("", value: $weightVal, formatter: NumberFormatter())
      }

      HStack {
        Button(action: save, label: { Text("Sichern").padding(.all, 5) })
        Spacer()
        Button(action: cancel, label: { Text("Abbrechen").padding(.all, 5) })
      }
      .padding(.top, 30)
    }
    .padding(30)
      .onAppear(perform: initializeState)
  }

  var weight: Weight?
  var onSave: SaveCallback?
  var onCancel: CancelCallback?


  // MARK: - Private Properties

  private var mode: Mode

  @Environment(\.presentationMode)
  private var presentationMode

  @State
  private var dateVal: Date = Date()
  @State
  private var weightVal: Float = 0


  // MARK: - Initialization

  init(weight: Weight? = nil, mode: Mode, onSave: SaveCallback? = nil, onCancel: CancelCallback? = nil) {
    self.weight = weight
    self.mode = mode
    self.onSave = onSave
    self.onCancel = onCancel

    initializeState()
  }


  // MARK: - Private Methods

  private func EditorTitle() -> some View {
    return
      Text(mode == .create ? "Gewicht erstellen" : "Gewicht bearbeiten")
        .font(.title)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
  }

  private func initializeState() {
    switch mode {
      case .create:
        dateVal = Date()
        weightVal = 0
        break

      case .edit:
        guard let weight = weight else {
          // Show Error and close
          DispatchQueue.main.async {
            presentationMode.wrappedValue.dismiss()
          }
          DispatchQueue.main.async {
            errorAlert(message: "Es wurde kein Gewicht zur Bearbeitung gefunden!")
          }
          return
        }
        dateVal = weight.date!
        weightVal = weight.weight!
        break
    }
  }

  private func save() {
    DispatchQueue.main.async {
      presentationMode.wrappedValue.dismiss()
    }
    DispatchQueue.main.async {
      onSave?(dateVal, weightVal)
    }
  }

  private func cancel() {
    DispatchQueue.main.async {
      presentationMode.wrappedValue.dismiss()
    }
    DispatchQueue.main.async {
      onCancel?()
    }
  }
}
