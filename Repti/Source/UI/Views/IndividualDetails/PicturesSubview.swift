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
             /*   .contextMenu {
                  Button {
                    delete(picture: picture)
                  } label: {
                    Image(systemName: "trash")
                    Text("Delete")
                  }
                }*/
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
        } label: {
          Image(systemName: "rectangle.badge.plus")
            .padding(.horizontal, 10)
        }
        .disabled(!expanded)
      }
    }
  }


  // MARK: - Private Properties

  @State
  internal var showImageViewer = false


  // MARK: - Private Methods

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
