//
//  DatesSubview.swift
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

import PureSwiftUI

struct DatesSubview: View {

  // MARK: - Public Properties

  @Binding
  var individual: Individual

  @Binding
  var expanded: Bool

  var body: some View {
    DisclosureGroup(isExpanded: $expanded, content: {
      // Dates
      LazyVGrid(
        columns: [
          GridItem(alignment: .trailing), GridItem(alignment: .leading),
          GridItem(alignment: .trailing), GridItem(alignment: .leading)]) {

        RenderIf(individual.ovipositionDate != nil) {
          Text(LocalizedStringKey("Oviposition Date:"))
          datePicker($individual.ovipositionDate)
        }

        RenderIf(individual.hatchingDate != nil) {
          Text(LocalizedStringKey("Hatching Date:"))
          datePicker($individual.hatchingDate)
        }

        RenderIf(individual.purchasingDate != nil) {
          Text(LocalizedStringKey("Purchasing Date:"))
          datePicker($individual.purchasingDate)
        }

        RenderIf(individual.dateOfSale != nil) {
          Text(LocalizedStringKey("Date of Sale:"))
          datePicker($individual.dateOfSale)
        }
      }
      .padding(.vertical, 10)
    }) {
      HStack {
        Text(LocalizedStringKey("Dates")).font(.title)
        Spacer()
        Menu("Dates") {
          Toggle(isOn: ovipositionDateBinding()) {
            Text(LocalizedStringKey("Oviposition Date"))
          }
          Toggle(isOn: hatchingDateBinding()) {
            Text(LocalizedStringKey("Hatching Date"))
          }
          Toggle(isOn: purchasingDateBinding()) {
            Text(LocalizedStringKey("Purchasing Date"))
          }
          Toggle(isOn: dateOfSaleBinding()) {
            Text(LocalizedStringKey("Date of Sale"))
          }
        }
      }
    }
  }


  // MARK: - Private Methods: UI

  private func datePicker(_ binding: Binding<Date?>) -> some View {
    return
      DatePicker(
        "Please enter a date",
        selection:
          Binding<Date>(
            get: { binding.wrappedValue! },
            set: { binding.wrappedValue = $0 }),
        displayedComponents: .date)
      .labelsHidden()
  }
  

  // MARK: - Private Methods: Binding for Dates

  private func ovipositionDateBinding() -> Binding<Bool> {
    return
      Binding {
        return individual.ovipositionDate != nil
      } set: { enabled in
        individual.ovipositionDate = enabled ? Date() : nil
      }
  }

  private func hatchingDateBinding() -> Binding<Bool> {
    return
      Binding {
        return individual.hatchingDate != nil
      } set: { enabled in
        individual.hatchingDate = enabled ? Date() : nil
      }
  }

  private func purchasingDateBinding() -> Binding<Bool> {
    return
      Binding {
        return individual.purchasingDate != nil
      } set: { enabled in
        individual.purchasingDate = enabled ? Date() : nil
      }
  }

  private func dateOfSaleBinding() -> Binding<Bool> {
    return
      Binding {
        return individual.dateOfSale != nil
      } set: { enabled in
        individual.dateOfSale = enabled ? Date() : nil
      }
  }
}


// MARK: - Preview

struct DatesSubview_Previews: PreviewProvider {
  static var previews: some View {
    DatesSubview(
      individual: Binding(get: { Individual() }, set: { _ in }),
      expanded: Binding(get: { true }, set: { _ in }))
  }
}
