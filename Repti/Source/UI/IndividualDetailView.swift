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
  @State
  private var showWeighingData = false
  @State
  private var updateAllSectionExpandedFlag = true
  @State
  private var sectionsExpanded = true {
    didSet {
      if updateAllSectionExpandedFlag {
        withAnimation {
          datesSectionExpanded = sectionsExpanded
          weighingsSectionExpanded = sectionsExpanded
        }
      }
    }
  }
  @State
  private var datesSectionExpanded = true {
    didSet {
      updateAllSectionExpandedFlag = false
      sectionsExpanded = datesSectionExpanded
      updateAllSectionExpandedFlag = true
    }
  }
  @State
  private var weighingsSectionExpanded = true {
    didSet {
      updateAllSectionExpandedFlag = false
      sectionsExpanded = weighingsSectionExpanded
      updateAllSectionExpandedFlag = true
    }
  }
  @Environment(\.managedObjectContext)
  private var viewContext


  // MARK: - Public Properties

  @Binding
  var individual: Individual

  var body: some View {
    GeometryReader { geo in
      ScrollView(.vertical) {

        headerSection()

        Divider()
          .padding(.top, 20)

        datesSection(geometry: geo)

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

        weighingsSections(geometry: geo)
      }
      .navigationBarTitle(Text(individual.name))
      .navigationBarItems(
        leading: Spacer(),
        trailing: 
        HStack {
          Button(action: { sectionsExpanded = !sectionsExpanded }) {
            Image(
              systemName:
                sectionsExpanded
                ? "rectangle.arrowtriangle.2.inward"
                : "rectangle.arrowtriangle.2.outward")
          }
        }
      )
      .padding(.all, 20)
    }
  }


  // MARK: - View Sections

  fileprivate func headerSection() -> AnyView {
    return AnyView(
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
        .padding(.trailing, 30)
      }
      .padding([.vertical, .trailing], 5))
  }

  fileprivate func datesSection(geometry geo: GeometryProxy) -> AnyView {
    return AnyView(
      Group {
        VStack(alignment: .leading) {
          HStack {
            Text("Dates").font(.title)
            Button(
              action: {
                withAnimation {
                  datesSectionExpanded = !datesSectionExpanded
                }
              }) {
              if datesSectionExpanded {
                Image(systemName: "chevron.down")
              } else {
                Image(systemName: "chevron.right")
              }
            }
          }.frame(width: geo.size.width, alignment: .leading)
          if datesSectionExpanded {
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
      }
      .padding(.top, 20))
  }

  fileprivate func weighingsSections(geometry geo: GeometryProxy) -> AnyView {
    return AnyView(
      Group {
        VStack(alignment: .leading) {
          HStack {
            Text("Weighings").font(.title)
            Button(
              action: {
                withAnimation {
                  weighingsSectionExpanded = !weighingsSectionExpanded
                }
              }) {
              if weighingsSectionExpanded {
                Image(systemName: "chevron.down")
              } else {
                Image(systemName: "chevron.right")
              }
            }.padding(.trailing, 10)
            Button(action: { showWeighingEditor = true} ) {
              Image(systemName: "plus")
            }
            .popover(isPresented: $showWeighingEditor, content: {
              WeighingsEditorView(saveHandler: self.saveWeighing(weight:))
            })
          }.frame(width: geo.size.width, alignment: .leading)

          if weighingsSectionExpanded {
            if individual.weighings?.count == 0 {
              Text("No data availabe.").frame(minWidth: geo.size.width - 30)
            } else {
              VStack {
                Toggle("Show data", isOn: $showWeighingData)

                HStack {
                  LineView(data: sortedWeights(), legend: "Weight")
                    .frame(maxWidth: (geo.size.width / (showWeighingData ? 2 : 1)) - 40, minHeight: 0, maxHeight: .infinity)

                  if showWeighingData {
                    weighingsDataList()
                  }
                }
                .frame(height: 300)
              }
            }
          }
        }
      }
      .padding(.top, 20)
    )
  }

  fileprivate func weighingsDataList() -> AnyView {
    return AnyView(
      VStack(alignment: .leading) {
        Text("Weight Data")
          .font(.callout)
          .padding([.top, .bottom], 20)

        List {
          let dateFormatter = weighingDateFormatter()

          ForEach(
            Array(individual.weighings!)
              .sorted { (weight1, weight2) -> Bool in
                weight1.date < weight2.date
              }) { weighing in

            LazyVGrid(columns: [GridItem(), GridItem()]) {

              Text(dateFormatter.string(from: weighing.date))
              Text(String(format: "%.0f", weighing.weight))
            }
          }
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .padding(.trailing, 30)
      }
    )
  }


  // MARK: - Private Methods

  private func weighingDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none

    return formatter
  }

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
                get: { binding.wrappedValue! },
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
