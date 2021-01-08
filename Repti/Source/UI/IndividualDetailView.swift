//
//  IndividualDetailView.swift
//  Repti
//
//  Created by Thomas Bonk on 06.01.21.
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
import SwiftUICharts

extension Binding {
  init<T>(isNotNil source: Binding<T?>, defaultValue: T) where Value == Bool {
    self.init(get: { source.wrappedValue != nil },
              set: { source.wrappedValue = $0 ? defaultValue : nil })
  }
}

struct IndividualDetailView: View {

  // MARK: - Private Properties

  @State
  private var showIndividualEditor = false
  @State
  private var showWeighingEditor = false
  @Environment(\.managedObjectContext)
  private var viewContext


  // MARK: - Public Properties

  @Binding
  var individual: Individual

  var body: some View {
    GeometryReader { geo in
      ScrollView(.vertical) {
        HStack {
          Text("Name:").font(.headline)
          TextField("Enter Name", text: $individual.name)
          Text("Gender:").font(.headline).padding(.leading, 10)
          Picker(selection: $individual.genderVal, label: Text("Gender")) {
            ForEach(Gender.allCases) { gender in
              Text(gender.displayName).tag(gender.rawValue)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        .padding([.vertical, .trailing], 5)

        Divider()
          .padding(.top, 20)

        Group {
          VStack(alignment: .leading) {
            Text("Dates").font(.title)
            LazyVGrid(
              columns: [
                GridItem(alignment: .trailing), GridItem(alignment: .leading),
                GridItem(alignment: .trailing), GridItem(alignment: .leading)],
              content: {
                Group {
                  Text("Oviposition Date:").font(.headline)
                  optionalDatePicker($individual.ovipositionDate)

                  Text("Hatching Date:").font(.headline)
                  optionalDatePicker($individual.hatchingDate)
                }.padding(.bottom, 10)

                Group {
                  Text("Purchasing Date:").font(.headline)
                  optionalDatePicker($individual.purchasingDate)

                  Text("Sold on:").font(.headline)
                  optionalDatePicker($individual.dateOfSale)
                }
              })
          }
        }
        .padding(.top, 20)

/*        Divider().padding(.top, 20)

        Group {
          VStack(alignment: .leading) {
            HStack {
              Text("Pictures").font(.title)
              Button(action: {} ) {
                Image(systemName: "plus")
              }
            }

            if individual.pictures?.count == 0 {
              Text("No pictures availabe.").frame(minWidth: geo.size.width - 30)
            } else {
            }
          }
        }
        .padding(.top, 20)
 */

        Divider().padding(.top, 20)

        Group {
          VStack(alignment: .leading) {
            HStack {
              Text("Weighings").font(.title)
              Button(action: { showWeighingEditor = true} ) {
                Image(systemName: "plus")
              }
              .popover(isPresented: $showWeighingEditor, content: {
                WeighingsEditorView(saveHandler: self.saveWeighing(weight:))
              })
            }

            if individual.weighings?.count == 0 {
              Text("No data availabe.").frame(minWidth: geo.size.width - 30)
            } else {
              LineView(data: sortedWeights(), legend: "Weight")
                .frame(width: geo.size.width - 40)
            }
          }
        }
        .padding(.top, 20)
      }
      .navigationBarTitle(Text(individual.name))
      .padding(.all, 20)
    }
  }


  // MARK: - Private Methods

  private func saveWeighing(weight: WeightDAO) {
    let weighing = Weight.create(in: viewContext)

    weighing.date = weight.date
    weighing.weight = weight.weight
    weighing.individual = individual
    individual.addToWeighings(weighing)

    do {
      try viewContext.save()
    } catch {
      errorAlert(message: "Error while saving a weighing.", error: error)
    }
  }

  private func sortedWeights() -> [Double] {
    return
      Array(individual.weighings!)
      .sorted { (weight1, weight2) -> Bool in
        weight1.date < weight2.date
      }
      .map { weight in
        Double(weight.weight)
      }
  }

  private func optionalDatePicker(_ binding: Binding<Date?>) -> some View {
    return
      HStack {
        Toggle("", isOn: Binding(isNotNil: binding, defaultValue: Date()))

        if binding.wrappedValue != nil {
          DatePicker(
            "Please enter a date",
            selection:
              Binding<Date>(
                get: { binding.wrappedValue ?? Date() },
                set: { binding.wrappedValue = $0 }),
            displayedComponents: .date)
            .labelsHidden()
        }
      }
  }
}

struct IndividualDetailView_Previews: PreviewProvider {
  static var previews: some View {
    Text("Individual Detail Screen")
    //IndividualDetailView()
  }
}
