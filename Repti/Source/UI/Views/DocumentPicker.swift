//
//  DocumentPicker.swift
//  Repti
//
//  Created by Thomas Bonk on 23.02.21.
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
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {

  // MARK: - Public Properties

  public var documentSelectedHandler: (URL) -> ()


  // MARK: - UIViewControllerRepresentable

  func makeCoordinator() -> DocumentPickerCoordinator {
    return DocumentPickerCoordinator(handler: documentSelectedHandler)
  }

  func makeUIViewController(
    context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentBrowserViewController {

    let controller = UIDocumentBrowserViewController(forOpening: [.pdf, .jpeg, .png, .tiff, .image, .content])

    //controller.allowsMultipleSelection = false
    controller.shouldShowFileExtensions = true
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(
    _ uiViewController: UIDocumentBrowserViewController,
    context: UIViewControllerRepresentableContext<DocumentPicker>) {

    uiViewController.delegate = context.coordinator
  }
}

class DocumentPickerCoordinator: NSObject, UIDocumentBrowserViewControllerDelegate { //, UINavigationControllerDelegate {

  // MARK: - Private Properties

  private var documentSelectedHandler: (URL) -> ()


  // MARK: - Initialization

  fileprivate init(handler: @escaping (URL) -> ()) {
    documentSelectedHandler = handler
    super.init()
  }


  // MARK: - UIDocumentPickerDelegate

  func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt urls: [URL]) {
    documentSelectedHandler(urls[0])
  }
}

struct DocumentPicker_Previews: PreviewProvider {
  static var previews: some View {
    DocumentPicker(documentSelectedHandler: { _ in })
  }
}
