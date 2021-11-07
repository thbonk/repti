//
//  WeighingsSubview.swift
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
import SwiftUICharts

struct WeighingsSubview: View {

  // MARK: - Public Properties
  
  var body: some View {
    VStack(alignment: .leading) {
      Divider()
      SubviewHeader()
        .padding(.bottom, 10)

      TabView {
        LineChartView(dataPoints: sortedWeights())
          .tabItem { Text("Diagramm") }
          .padding()
        DataList()
          .tabItem { Text("Daten") }
          .padding()
      }
      .font(.headline)
    }
    .sheet(isPresented: $showWeighingEditor) {
      WeightEditorView(
          weight: editWeight.value?.weight,
            mode: editWeight.value!.mode,
          onSave: save(date:weight:),
        onCancel: cancel)
    }
  }

  @Binding
  var individual: Individual


  // MARK: - Private Properties

  @Environment(\.managedObjectContext)
  private var viewContext

  @State
  private var selectedWeight: UUID!
  @State
  private var showWeighingEditor: Bool = false
  @ObservedObject
  private var editWeight = ValueWrapper<(weight: Weight?, mode: WeightEditorView.Mode)>()


  // MARK: - Private Methods

  private func SubviewHeader() -> some View {
    return
      HStack(alignment: .center) {
        Text("Gewicht").bold()
        Spacer()
        Button(action: addWeight, label: { Image(sfSymbol: .calendar_badge_plus) })
          .padding(.trailing, 10)
        Button {
          // TODO edit selected weight
        } label: {
          Image(sfSymbol: .square_and_pencil)
        }
        .disabled(selectedWeight == nil)
        .padding(.trailing, 10)
        Button {
          // TODO delete selected weight
        } label: {
          Image(sfSymbol: .trash_square)
        }
        .disabled(selectedWeight == nil)
      }
      .buttonStyle(BorderlessButtonStyle())
  }

  private func DataList() -> some View {
    let dateFormatter = weighingDateFormatter()

    return List(Array(individual.weighings ?? []), selection: $selectedWeight) { weight in
      HStack {
        Text("\(dateFormatter.string(from: weight.date!))")
        Spacer()
        Text("\(Int(weight.weight!))")
      }
    }
  }

  private func addWeight() {
    editWeight.value = (weight: nil, mode: .create)
    showWeighingEditor = true
  }

  private func sortedWeights() -> [DataPoint] {
    let legend = Legend(color: .red, label: "Gewicht", order: 1)
    let dateFormatter = weighingDateFormatter()

    return
      Array(individual.weighings!)
        .sorted { (weight1, weight2) -> Bool in
          weight1.date! < weight2.date!
        }
        .map { weight in
          DataPoint(
            value: Double(weight.weight!),
            label: LocalizedStringKey(dateFormatter.string(from: weight.date!)),
            legend: legend)
        }
  }

  private func weighingDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none

    return formatter
  }

  private func save(date: Date, weight: Float) {
    if let wght = editWeight.value?.weight {
      wght.date = date
      wght.weight = weight
      editWeight.value = nil
    } else {
      let wght = Weight.create(in: viewContext)
      wght.date = date
      wght.weight = weight
      wght.individual = individual
      individual.addToWeighings(wght)
    }

    do {
      try viewContext.save()
    } catch {
      errorAlert(
        message: "Fehler beim Speichern der Daten.",
        error: error)
    }
  }

  private func cancel() {
    viewContext.rollback()
  }
}
