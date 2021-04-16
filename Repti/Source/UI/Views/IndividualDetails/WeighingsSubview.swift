//
//  WeighingsSubview.swift
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
import SwiftUICharts

struct WeighingsSubview: View {

  // MARK: - Public Properties

  @Binding
  var individual: Individual

  @Binding
  var expanded: Bool
  
  var body: some View {
    DisclosureGroup(isExpanded: $expanded, content: {
      RenderIf((individual.weighings?.count ?? 0) > 0) {
        HStack {
          LineView(data: sortedWeights(), legend: "Weight")
            .popover(isPresented: $showWeighingEditor) {

              WeighingsEditorView(
                weight: editWeighing.value!.dao,
                mode: editWeighing.value!.mode,
                onSave: saveWeighing(weight:),
                onDismiss: editorDismissed)
            }

          RenderIf(showWeighingData) {
            weighingsDataList()
              .padding(.leading, 10)
          }
        }
        .frame(height: 300)
      }
      .elseRender {
        Text(LocalizedStringKey("No data awvailable"))
      }
    }) {
      HStack {
        Text(LocalizedStringKey("Weighings")).font(.title)
        Spacer()
        Toggle(LocalizedStringKey("Show data"), isOn: $showWeighingData)
          .disabled(!expanded)
        Button {
          editWeighing.value = (weight: nil, dao: WeightDAO(date: Date(), weight: 0), mode: .create)
          showWeighingEditor = true
        } label: {
          Image(systemName: "calendar.badge.plus")
            .padding(.horizontal, 10)
        }
        .disabled(!expanded)
      }
    }
    .padding(.vertical, 10)
  }


  // MARK: - Private Properties

  @State
  private var showWeighingData = false

  @State
  private var showWeighingEditor = false

  @State
  private var editWeighing = OptionalValue<(weight: Weight?, dao: WeightDAO, mode: WeighingsEditorView.Mode)>()

  @Environment(\.managedObjectContext)
  private var viewContext

  


  // MARK: - Private Methods

  private func saveWeighing(weight weightDao: WeightDAO) throws {
    if let weight = editWeighing.value?.weight {
      weight.date = weightDao.date
      weight.weight = weightDao.weight
    } else {
      let weight = Weight.create(in: viewContext)

      weight.date = weightDao.date
      weight.weight = weightDao.weight
      individual.addToWeighings(weight)
      weight.individual = individual
    }

    try viewContext.save()
  }

  private func editorDismissed() {
    editWeighing.value = nil
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

  private func weighingDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none

    return formatter
  }


  // MARK: - Private Methods: UI

  private func weighingsDataList() -> some View {
    return
      VStack(alignment: .leading) {
        Text(LocalizedStringKey("Weight Data"))
          .font(.callout)
          .padding([.top, .bottom], 20)

        List {
          let dateFormatter = weighingDateFormatter()

          ForEach(Array(individual.weighings!).sorted(by: dateDescending), id: \.id) { weighing in
            LazyVGrid(columns: [GridItem(), GridItem()]) {
              Text(dateFormatter.string(from: weighing.date))
              Text(String(format: "%.0f", weighing.weight))
            }
            .contextMenu {
              Button {
                editWeighing.value = (weight: weighing, dao: WeightDAO(weighing: weighing), mode: .edit)
                showWeighingEditor = true
              } label: {
                HStack {
                  Image(systemName: "square.and.pencil")
                  Text(LocalizedStringKey("Edit"))
                }
              }
            }
          }
        }
        .frame(minHeight: 0, maxHeight: .infinity)
      }
  }

  private func dateDescending(_ weight1: Weight, _ weight2: Weight) -> Bool {
    return weight1.date < weight2.date
  }
}


// MARK: - Preview

struct WeighingsSubview_Previews: PreviewProvider {
  static var previews: some View {
    WeighingsSubview(
      individual: Binding(get: { Individual() }, set: { _ in }),
      expanded: Binding(get: { true }, set: { _ in }))
  }
}
