//
//  ImageViewer.swift
//  Repti
//
//  Created by Thomas Bonk on 15.02.21.
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

struct ImageViewer: View {

  // MARK: - Private Properties

  @Environment(\.presentationMode)
  private var presentationMode
  private var isFirstPicture: Bool {
    return (pictures.firstIndex(of: currentPicture) ?? 0) == 0
  }
  private var isLastPicture: Bool {
    return (pictures.firstIndex(of: currentPicture) ?? (pictures.count - 1)) == (pictures.count - 1)
  }


  // MARK: - Public Properties

  public var pictures: Array<Picture>
  @State
  public var currentPicture: Picture

  var body: some View {
    withAnimation(.easeInOut) {
      GeometryReader { geo in
        imageView(geometry: geo)
      }
    }
  }


  // MARK: - Private Methods

  private func imageView(geometry geo: GeometryProxy) -> AnyView {
    return
      AnyView(
        ZStack {
          Image(uiImage: UIImage(data: currentPicture.pictureData!.data!)!)
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .cornerRadius(10)

          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(systemName: "xmark.circle.fill")
          }
          .offset(x: -geo.size.width / 2 + 20, y: -geo.size.height / 2 + 20)
          Button {
            if let index = pictures.firstIndex(of: currentPicture) {
              currentPicture = pictures[index - 1]
            }
          } label: {
            Image(systemName: "chevron.left.circle.fill")
          }
          .offset(x: -geo.size.width / 2 + 20)
          .disabled(isFirstPicture)
          Button {
            if let index = pictures.firstIndex(of: currentPicture) {
              currentPicture = pictures[index + 1]
            }
          } label: {
            Image(systemName: "chevron.right.circle.fill")
          }
          .offset(x: geo.size.width / 2 - 20)
          .disabled(isLastPicture)
        })
  }
}

struct ImageViewer_Previews: PreviewProvider {
  static var previews: some View {
    //ImageViewer()
    Text("")
  }
}
