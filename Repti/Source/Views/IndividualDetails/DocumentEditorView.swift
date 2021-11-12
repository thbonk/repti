//
//  DocumentEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 09.11.21.
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
import SwiftUI

struct DocumentEditorView: View {

  // MARK: - Public Typealiases

  typealias SaveCallback = (URL?, Date, String) -> Void
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
        Text("Dateiname:")
        Text(filename)
        Text("Datum:")
        DatePicker("", selection: $date, displayedComponents: .date).pickerStyle(MenuPickerStyle())
        Text("Bemerkung:")
        TextField("", text: $notes)
      }

      HStack {
        Button(action: cancel, label: { Text("Abbrechen").padding(.all, 5) })
        Spacer()
        Button(action: save, label: { Text("Sichern").padding(.all, 5) })
      }
      .padding(.top, 30)
    }
    .padding(30)
    .onAppear(perform: initializeFromValues)
  }

  var document: Document?
  var url: URL?
  var mode: Mode
  var onSave: SaveCallback? = nil
  var onCancel: CancelCallback? = nil


  // MARK: - Private Properties

  @Environment(\.presentationMode)
  private var presentationMode

  @State
  private var filename: String = ""
  @State
  private var date: Date = Date()
  @State
  private var notes: String = ""


  // MARK: - Private Methods

  private func EditorTitle() -> some View {
    return
      RenderIf(mode == .create) {
        Text("Dokument erstellen")
      }.elseRender {
        Text("Dokument bearbeiten")
      }
      .font(.title)
      .padding(.horizontal, 30)
      .padding(.bottom, 30)
  }

  private func initializeFromValues() {
    if let doc = document {
      filename = doc.filename!
      date = doc.date!
      notes = doc.notes!
    } else {
      filename = url!.lastPathComponent
      date = Date()
      notes = ""
    }
  }

  private func save() {
    DispatchQueue.main.async {
      presentationMode.wrappedValue.dismiss()
    }
    DispatchQueue.main.async {
      onSave?(url, date, notes)
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
