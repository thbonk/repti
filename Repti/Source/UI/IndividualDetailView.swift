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
  internal var showIndividualEditor = false
  @State
  internal var showWeighingEditor = false
  @State
  internal var showWeighingData = false

  @State
  internal var showImagePicker = false
  @State
  internal var image: Image? = Image("placeholder")

  @State
  internal var updateAllSectionExpandedFlag = true
  @State
  internal var sectionsExpanded = true {
    didSet {
      if updateAllSectionExpandedFlag {
        withAnimation {
          datesSectionExpanded = sectionsExpanded
          picturesSectionExpanded = sectionsExpanded
          weighingsSectionExpanded = sectionsExpanded
        }
      }
    }
  }
  @State
  internal var datesSectionExpanded = true {
    didSet {
      updateAllSectionExpandedFlag = false
      sectionsExpanded = datesSectionExpanded
      updateAllSectionExpandedFlag = true
    }
  }
  @State
  internal var picturesSectionExpanded  = true {
    didSet {
      updateAllSectionExpandedFlag = false
      sectionsExpanded = picturesSectionExpanded
      updateAllSectionExpandedFlag = true
    }
  }
  @State
  internal var weighingsSectionExpanded = true {
    didSet {
      updateAllSectionExpandedFlag = false
      sectionsExpanded = weighingsSectionExpanded
      updateAllSectionExpandedFlag = true
    }
  }
  @State
  internal var showImageViewer = false
  @Environment(\.managedObjectContext)
  internal var viewContext


  // MARK: - Public Properties

  @Binding
  var individual: Individual

  var body: some View {
    GeometryReader { geo in
      ScrollView(.vertical) {
        if UIDevice.current.userInterfaceIdiom == .phone {
          smallUserInterface(geometry: geo)
        } else {
          largeUserInterface(geometry: geo)
        }
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


  // MARK: - Private Methods

  internal func savePicture(image: UIImage) {
    let picture = Picture.create(in: viewContext)
    picture.filename = "\(individual.name)-\(individual.pictures!.count + 1)"
    picture.individual = individual
    individual.addToPictures(picture)

    let pictureData = PictureData.create(in: viewContext)
    pictureData.data = image.jpegData(compressionQuality: 1)
    pictureData.picture = picture
    picture.pictureData = pictureData

    do {
      try viewContext.save()
    } catch {
      errorAlert(message: "Error while saving a picture.", error: error)
    }
  }

  internal func delete(picture: Picture) {
    viewContext.delete(picture)
    do {
      try viewContext.save()
    } catch {
      errorAlert(message: "Error while deleting a picture.", error: error)
    }
  }

  internal func weighingDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none

    return formatter
  }

  internal func saveWeighing(weight: WeightDAO) {
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

  internal func sortedWeights() -> [Double] {
    return
      Array(individual.weighings!)
      .sorted { (weight1, weight2) -> Bool in
        weight1.date < weight2.date
      }
      .map { weight in
        Double(weight.weight)
      }
  }

  internal func optionalDatePicker(_ binding: Binding<Date?>) -> some View {
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
