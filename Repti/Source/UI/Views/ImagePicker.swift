//
//  ImagePicker.swift
//  Repti
//
//  Created by Thomas Bonk on 21.01.21.
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

import Foundation
import UIKit
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {

  // MARK: - Public Properties

  @State
  public var selectHandler: (UIImage) -> ()


  // MARK: - Private Properties
  
  @Environment(\.presentationMode)
  private var presentationMode


  // MARK: - UIViewControllerRepresentable

  func makeCoordinator() -> Coordinator {
    return Coordinator(presentationMode: presentationMode, selectHandler: selectHandler)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()

    configuration.filter = .images
    configuration.selectionLimit = 0

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator

    return picker
  }

  func updateUIViewController(
    _ uiViewController: PHPickerViewController,
    context: UIViewControllerRepresentableContext<ImagePicker>) {

  }


  class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    private var selectHandler: ((UIImage) -> ())? = nil

    @Binding var presentationMode: PresentationMode

    init(presentationMode: Binding<PresentationMode>, selectHandler: ((UIImage) -> ())? = nil) {
      self.selectHandler = selectHandler
      _presentationMode = presentationMode
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      results.forEach { result in
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
          result.itemProvider.loadObject(ofClass: UIImage.self) { [self] image, error in
            DispatchQueue.main.async {
              if let image = image as? UIImage {
                self.selectHandler?(image)
              }
            }
          }
        }
      }

      picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      presentationMode.dismiss()

      selectHandler?(uiImage)
    }

    //func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //  presentationMode.dismiss()
    //}

  }
}


struct ImagePicker_Previews: PreviewProvider {
  static var previews: some View {
    Text("")
    //ImagePicker(image: $image)
  }
}
