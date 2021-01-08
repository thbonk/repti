//
//  WeighingsEditorView.swift
//  Repti
//
//  Created by Thomas Bonk on 08.01.21.
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
import Combine

struct WeighingsEditorView: View {

  // MARK: - Private Properties

  @State
  private var model: WeightDAO = WeightDAO(date: Date(), weight: 0)
  @State
  private var weight = ""
  @Environment(\.presentationMode)
  private var presentationMode


  // MARK: - Public Properties

  var saveHandler: ((WeightDAO) -> ())? = nil

  var body: some View {
    Group {
      LazyVGrid(
        columns: [
          GridItem(alignment: .trailing), GridItem(alignment: .leading)],
        content: {
          Group {
            Text("Date:").font(.headline)
            DatePicker(
              "Please enter a date",
              selection: $model.date,
              displayedComponents: .date)
              .labelsHidden()

            Text("Weight:").font(.headline)
            TextField("Enter weight", text: $weight)
              .keyboardType(.numberPad)
              .onReceive(Just(weight)) { newValue in
                let filtered = newValue.filter { "0123456789.".contains($0) }
                if filtered == newValue && filtered.count > 0 {
                  weight = filtered
                  model.weight = Float(weight)!
                }
              }
              .onAppear(perform: { self.weight = "\(model.weight)" })
          }
        })

      Button("Save", action: {
        saveHandler?(model)
        self.presentationMode.wrappedValue.dismiss()
      })
      .padding(.top, 20)
    }
    .padding(.all, 20)
    .frame(minWidth: 250, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
  }
}

struct WeighingsEditorView_Previews: PreviewProvider {
  static var previews: some View {
    WeighingsEditorView()
  }
}
