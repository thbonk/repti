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
  internal var showDocumentPicker = false
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
          documentsSectionExpanded = sectionsExpanded
        }
      }
    }
  }
  @State
  internal var datesSectionExpanded = true {
    didSet {
      sectionExpandStateChanged(datesSectionExpanded)
    }
  }
  @State
  internal var picturesSectionExpanded  = true {
    didSet {
      sectionExpandStateChanged(picturesSectionExpanded)
    }
  }
  @State
  internal var weighingsSectionExpanded = true {
    didSet {
      sectionExpandStateChanged(weighingsSectionExpanded)
    }
  }
  @State
  internal var documentsSectionExpanded = true {
    didSet {
      sectionExpandStateChanged(documentsSectionExpanded)
    }
  }
  @State
  internal var showImageViewer = false
  @State
  private var fileUrl = URL(fileURLWithPath: "/")
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


  // MARK: - View Sections

  internal func sectionExpandStateChanged(_ expanded: Bool) {
    updateAllSectionExpandedFlag = false
    sectionsExpanded = expanded
    updateAllSectionExpandedFlag = true
  }

  internal func picturesSection(geometry geo: GeometryProxy) -> AnyView {
    return AnyView(
      Group {
        VStack(alignment: .leading) {
          HStack {
            Text("Pictures").font(.title)
            Button(
              action: {
                withAnimation {
                  picturesSectionExpanded = !picturesSectionExpanded
                }
              }) {
              if picturesSectionExpanded {
                Image(systemName: "chevron.down")
              } else {
                Image(systemName: "chevron.right")
              }
            }.padding(.trailing, 10)
            Button(action: {
              showImagePicker = true
            }) {
              Image(systemName: "plus")
            }
            .sheet(isPresented: $showImagePicker) {
              ImagePicker(selectHandler: savePicture(image:))
            }
          }
          .frame(width: geo.size.width, alignment: .leading)

          if picturesSectionExpanded {
            if individual.pictures?.count == 0 {
              Text("No pictures availabe.").frame(minWidth: geo.size.width - 30)
            } else {
              ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                  let pictures = Array(individual.pictures!)

                  ForEach(pictures) { picture in
                    AsyncImage(picture: picture, placeholder: { Image(systemName: "photo.fill") })
                      .contextMenu {
                        Button {
                          delete(picture: picture)
                        } label: {
                          Image(systemName: "trash")
                          Text("Delete")
                        }
                      }
                      .onTapGesture {
                        showImageViewer = true
                      }
                      .sheet(isPresented: $showImageViewer, content: {
                        ImageViewer(pictures: pictures, currentPicture: picture)
                      })
                  }
                }
              }
              .padding(.trailing, 40)
            }
          }
        }
      }
      .padding(.top, 20)
    )
  }

  internal func documentsSection(geometry geo: GeometryProxy) -> AnyView {
    return AnyView(
      Group {
        VStack(alignment: .leading) {
          HStack {
            Text("Documents").font(.title)
            Button(
              action: {
                withAnimation {
                  documentsSectionExpanded = !documentsSectionExpanded
                }
              }) {
              if documentsSectionExpanded {
                Image(systemName: "chevron.down")
              } else {
                Image(systemName: "chevron.right")
              }
            }.padding(.trailing, 10)
            Button(action: {
              showDocumentPicker = true
            }) {
              Image(systemName: "plus")
            }
            .sheet(isPresented: $showDocumentPicker) {
              DocumentPicker(documentSelectedHandler: saveDocument(fileUrl:))
            }
          }
          .frame(width: geo.size.width, alignment: .leading)

          if documentsSectionExpanded {
            if individual.documents?.count == 0 {
              Text("No documents availabe.").frame(minWidth: geo.size.width - 30)
            } else {
              Text("Documents list goeas here").frame(minWidth: geo.size.width - 30)
            }
          }
        }
      }
      .padding(.top, 20)
    )
  }


  // MARK: - Private Methods

  internal func saveDocument(fileUrl: URL) {
    do {
      let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
      let filedate = fileAttributes[.creationDate] as! Date
      let filename = fileUrl.lastPathComponent
      let filedata = try Data(contentsOf: fileUrl, options: .uncached)
      let document = Document.create(in: viewContext)
      let documentData = DocumentData.create(in: viewContext)

      document.filename = filename
      document.notes = ""
      document.date = filedate
      document.documentData = documentData
      document.individual = individual
      individual.addToDocuments(document)

      documentData.data = filedata
      documentData.document = document

      try viewContext.save()
    } catch {
      errorAlert(message: "Error while importing the document.", error: error)
    }
  }

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
