//
//  PicturesSubview.swift
//  Repti
//
//  Created by Thomas Bonk on 16.04.21.
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

struct PicturesSubview: View {

  // MARK: - Public Properties

  @Binding
  var individual: Individual

  @Binding
  var expanded: Bool

  var body: some View {
    DisclosureGroup(isExpanded: $expanded, content: {
      RenderIf((individual.weighings?.count ?? 0) > 0) {
        ScrollView(.horizontal, showsIndicators: true) {
          HStack(alignment: .top, spacing: 0) {
            let pictures = sortedPictures()

            ForEach(pictures, id: \.id) { picture in
              AsyncImage(loader: AsyncImageLoader(picture: picture))
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
                .sheet(isPresented: $showImageViewer) {
                  ImageViewer(pictures: pictures, currentPicture: picture)
                }
            }
          }
        }
      }.elseRender {
        Text(LocalizedStringKey("No pictures available"))
      }
    }) {
      HStack {
        Text(LocalizedStringKey("Pictures")).font(.title)
        Spacer()
        Button {
          showImagePicker = true
        } label: {
          Image(systemName: "rectangle.badge.plus")
            .padding(.horizontal, 10)
        }
        .sheet(isPresented: $showImagePicker) {
          ImagePicker(selectHandler: savePicture(image:))
        }
        .disabled(!expanded)
      }
    }
  }


  // MARK: - Private Properties

  @State
  private var showImagePicker = false

  @State
  private var showImageViewer = false

  @Environment(\.managedObjectContext)
  private var viewContext


  // MARK: - Private Methods

  private func savePicture(image: UIImage) {
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

  private func sortedPictures() -> [Picture] {
    return
      Array(individual.pictures!)
      .sorted { (pic1, pic2) -> Bool in
        pic1.updatedAt! < pic2.updatedAt!
      }
  }
}


// MARK: - Preview

struct PicturesSubview_Previews: PreviewProvider {
  static var previews: some View {
    PicturesSubview(
      individual: Binding(get: { Individual() }, set: { _ in }),
      expanded: Binding(get: { true }, set: { _ in }))
  }
}
