//
//  WeighingsEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 15.04.21.
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
import Combine

struct WeighingsEditorView: View {

  // MARK: - Public Typealiases

  public typealias OnSaveCallback = (WeightDAO) throws -> ()
  public typealias OnDismissCallback = () -> ()


  // MARK: - Public Enums

  public enum Mode {
    case create
    case edit
  }


  // MARK: - Public Properties

  @State
  public var weight: WeightDAO

  public var mode: Mode

  public var onSave: OnSaveCallback?
  public var onDismiss: OnDismissCallback?

  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text(LocalizedStringKey("Date"))) {
          DatePicker(
            LocalizedStringKey("Please enter a date"),
            selection: $weight.date,
            displayedComponents: .date)
            .labelsHidden()
        }

        Section(header: Text(LocalizedStringKey("Weight"))) {
          TextField(
            LocalizedStringKey("Enter weight"),
            text: $weightString)
            .onReceive(Just(weightString), perform: { newValue in
              let filtered = newValue.filter { "0123456789.".contains($0) }
              if filtered == newValue && filtered.count > 0 {
                weightString = filtered
                weight.weight = Float(weightString)!
              }
            })
            .keyboardType(.numberPad)
        }
      }
      .padding(.horizontal, 10)
      .navigationTitle(
        mode == .create
          ? LocalizedStringKey("Add Weighing")
          : LocalizedStringKey("Edit Weighing"))
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            do {
              try onSave?(weight)
              presentationMode.wrappedValue.dismiss()
            } catch {
              errorAlert(
                message: "Error while saving a weighing.",
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


  // MARK: - Private Properties

  @State
  private var weightString = ""

  @Environment(\.presentationMode)
  private var presentationMode
}


// MARK: - Preview

struct WeighingsEditorView_Previews: PreviewProvider {
  static var previews: some View {
    WeighingsEditorView(weight: Weight().dao, mode: .create)
  }
}
