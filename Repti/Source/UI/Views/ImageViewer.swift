//
//  ImageViewer.swift
//  Repti
//
//  Created by Thomas Bonk on 05.05.21.
//

import SwiftUI

struct ImageViewer: View {

  // MARK: - Public Properties

  var body: some View {
    withAnimation(.easeInOut) {
      GeometryReader { geo in
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
        }
      }
    }
  }

  public var pictures: Array<Picture>

  @State
  public var currentPicture: Picture


  // MARK: - Private Properties
  @Environment(\.presentationMode)
  private var presentationMode

  private var isFirstPicture: Bool {
    return (pictures.firstIndex(of: currentPicture) ?? 0) == 0
  }

  private var isLastPicture: Bool {
    return (pictures.firstIndex(of: currentPicture) ?? (pictures.count - 1)) == (pictures.count - 1)
  }
}

struct ImageViewer_Previews: PreviewProvider {
  static var previews: some View {
    ImageViewer(pictures: [], currentPicture: Picture())
  }
}
