//
//  IndividualDetailView+Large.swift
//  Repti
//
//  Created by Thomas Bonk on 07.02.21.
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

extension IndividualDetailView {
  func largeUserInterface(geometry geo: GeometryProxy) -> AnyView {
    return AnyView(
      VStack {
        headerSection()

        Divider()
          .padding(.top, 20)

        datesSection(geometry: geo)

        Divider().padding(.top, 20)

        picturesSection(geometry: geo)

        Divider().padding(.top, 20)

        weighingsSections(geometry: geo)
          .padding(.bottom, 20)
    })
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

  fileprivate func picturesSection(geometry geo: GeometryProxy) -> AnyView {
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
          }
          .frame(width: geo.size.width, alignment: .leading)

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
}
