//
//  AsyncImage.swift
//  Repti
//
//  Created by Thomas Bonk on 12.02.21.
//

import SwiftUI
import Cache

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
