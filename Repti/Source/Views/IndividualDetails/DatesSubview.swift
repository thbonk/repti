//
//  DatesSubview.swift
//  Repti
//
//  Created by Thomas Bonk on 05.11.21.
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

struct DatesSubview: View {

  // MARK: - Public Properties

  var body: some View {
    VStack(alignment: .leading) {
      Divider()
      HStack {
        HStack(alignment: .center) {
          Text("Daten").bold()
          Spacer()
          Toggle(isOn: dateIsBound($individual.ovipositionDate)) {
            Text(LocalizedStringKey("Eiablagedatum"))
          }
          Toggle(isOn: dateIsBound($individual.hatchingDate)) {
            Text(LocalizedStringKey("Schlupfdatum"))
          }
          Toggle(isOn: dateIsBound($individual.purchasingDate)) {
            Text(LocalizedStringKey("Kaufdatum"))
          }
          Toggle(isOn: dateIsBound($individual.dateOfSale)) {
            Text(LocalizedStringKey("Verkaufsdatum"))
          }
        }
      }

      RenderIf(anyDateAvailable) {
        LazyVGrid(
          columns: [
            GridItem(alignment: .trailing), GridItem(alignment: .leading),
            GridItem(alignment: .trailing), GridItem(alignment: .leading)],
          content: {
              RenderIf(individual.ovipositionDate != nil) {
                Text("Eiablage am")
                DatePicker(Binding($individual.ovipositionDate)!)
              }
              RenderIf(individual.hatchingDate != nil) {
                Text("Geschlüpft am")
                DatePicker(Binding($individual.hatchingDate)!)
              }
              RenderIf(individual.purchasingDate != nil) {
                Text("Gekauft am")
                DatePicker(Binding($individual.purchasingDate)!)
              }
              RenderIf(individual.dateOfSale != nil) {
                Text("Verkauft am")
                DatePicker(Binding($individual.dateOfSale)!)
              }
            })
        Spacer()
      }
      .elseRender {
        HStack {
          Spacer()
          Text("Kein Datum ausgewählt.")
          Spacer()
        }
      }
    }
    .padding(.vertical, 20)
    .onAppear {
      assesDateAvailability()
    }
  }

  @Binding
  var individual: Individual


  // MARK: - Private Properties

  @State
  private var anyDateAvailable: Bool = false


  // MARK: - Private Methods

  private func DatePicker(_ selection: Binding<Date>) -> some View {
    return
      SwiftUI.DatePicker("", selection: selection, displayedComponents: .date)
  }

  private func dateIsBound(_ binding: Binding<Date?>) -> Binding<Bool> {
    return
      Binding {
        return binding.wrappedValue != nil
      } set: { enabled in
        binding.wrappedValue = enabled ? Date() : nil
        assesDateAvailability()
      }
  }

  private func assesDateAvailability() {
    DispatchQueue.main.async {
      anyDateAvailable = individual.ovipositionDate != nil
        || individual.hatchingDate != nil
        || individual.purchasingDate != nil
        || individual.dateOfSale != nil
    }
  }
}

