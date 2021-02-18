//
//  AsyncImage.swift
//  Repti
//
//  Created by Thomas Bonk on 12.02.21.
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

fileprivate class ImageLoader: ObservableObject {

  @Published
  var image: UIImage?
  var picture: Picture

  init(picture: Picture) {
    self.picture = picture
  }

  func load() {
    DispatchQueue.main.async {
      self.image = UIImage(data: (self.picture.pictureData?.data)!)
    }
  }
}

struct AsyncImage: View {

  @StateObject
  private var loader: ImageLoader
  private let placeholder: SwiftUI.Image

  var body: some View {
    content
      .onAppear(perform: loader.load)
  }

  private var content: some View {
    Group {
      if loader.image != nil {
        Image(uiImage: loader.image!)
          .resizable()
          .scaledToFit()
          .frame(height: 150)
          .cornerRadius(10)
          .padding(.all, 10)
      } else {
        placeholder
          .resizable()
          .scaledToFit()
          .frame(height: 150)
          .cornerRadius(10)
          .padding(.all, 10)
      }
    }
  }

  init(picture: Picture, @ViewBuilder placeholder: () -> SwiftUI.Image) {
    self.placeholder = placeholder()
    _loader = StateObject(wrappedValue: ImageLoader(picture: picture))
  }
}

struct AsyncImage_Previews: PreviewProvider {
  static var previews: some View {
    //AsyncImage()
    Text("")
  }
}
