//
//  DocumentEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 10.05.21.
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

struct DocumentEditorView: View {

  // MARK: - Public Typealiases

  public typealias OnSaveCallback = (DocumentDAO) throws -> ()
  public typealias OnDismissCallback = () -> ()


  // MARK: - Public Enums

  public enum Mode {
    case create
    case edit
  }


  // MARK: - Public Properties

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text(LocalizedStringKey("Filename"))) {
          TextField(LocalizedStringKey("Enter Filename"), text: Binding(get: {
            document.filename ?? ""
          }, set: { text in
            document.filename = text
          }))
        }

        Section(header: Text(LocalizedStringKey("Document Date"))) {
          DatePicker(
            LocalizedStringKey("Please enter a date"),
            selection: Binding(get: {
              document.date ?? Date()
            }, set: { date in
              document.date = date
            }),
            displayedComponents: .date)
            .labelsHidden()
        }

        Section(header: Text(LocalizedStringKey("Notes"))) {
          TextEditor(text: Binding(get: {
            document.notes ?? ""
          }, set: { text in
            document.notes = text
          }))
        }
      }
      .navigationTitle(
        mode == .create
          ? LocalizedStringKey("Create Document")
          : LocalizedStringKey("Edit Document"))
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            do {
              try onSave?(document)
              presentationMode.wrappedValue.dismiss()
            } catch {
              errorAlert(
                message: "Error while saving a document.",
                error: error)
            }
          } label: {
            Text(LocalizedStringKey("Save"))
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            presentationMode.wrappedValue.dismiss()
            onDismiss?()
          } label: {
            Text(LocalizedStringKey("Cancel"))
          }
        }
      })
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  @State
  var document: DocumentDAO
  var mode: Mode
  var onSave: OnSaveCallback? = nil
  var onDismiss: OnDismissCallback? = nil
  @Environment(\.presentationMode)
  private var presentationMode
}

struct DocumentEditorView_Previews: PreviewProvider {
  static var previews: some View {
    DocumentEditorView(document: DocumentDAO(date: Date(), filename: "Test"), mode: .create)
  }
}
