//
//  QuickLookPreview.swift
//  Repti
//
//  Created by Thomas Bonk on 11.11.21.
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
import PureSwiftUI
import QuickLookUI

class QuickLookPreview: NSObject, QLPreviewPanelDataSource, NSWindowDelegate, ObservableObject {

  // MARK: - Public Properties

  @Published
  private(set) var previewOpen: Bool = false

  // MARK: - Private Properties

  private var url: NSURL


  // MARK: - Initialization

  init(url: URL) {
    self.url = url as NSURL
    super.init()
  }


  // MARK: - Public Methods

  func show() {
    let panel = QLPreviewPanel.shared()

    (panel! as NSWindow).delegate = self

    panel?.center()
    panel?.dataSource = self
    panel?.makeKeyAndOrderFront(nil)

    DispatchQueue.main.async {
      self.previewOpen = true
    }
  }


  // MARK: - QLPreviewPanelDataSource

  func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
    return 1
  }

  func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
    return url as QLPreviewItem
  }

  func windowWillClose(_ notification: Notification) {
    DispatchQueue.main.async {
      self.previewOpen = false
    }
  }
}
