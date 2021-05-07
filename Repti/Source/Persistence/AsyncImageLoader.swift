//
//  AsyncImageLoader.swift
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

import SwiftUI
import Foundation

class AsyncImageLoader: ObservableObject {

  // MARK: - Private Properties

  @Published
  public private(set) var image: Image = Image(systemName: "photo")


  // MARK: - Private Properties

  private var picture: Picture


  // MARK: - Initialization

  init(picture: Picture) {
    self.picture = picture
  }

  func load() {
    DispatchQueue.global(qos: .background).async {
      if let pictureData = self.picture.pictureData?.data {
        if let uiImg = UIImage(data: pictureData) {
          let img = Image(uiImage: uiImg)
          DispatchQueue.main.async {
            self.image = img
          }
        }
      }
    }
  }
}
