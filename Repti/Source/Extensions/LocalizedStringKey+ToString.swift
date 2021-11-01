//
//  LocalizedStringKey+ToString.swift
//  Repti
//
//  Created by Thomas Bonk on 01.11.21.
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
import SwiftUI

extension LocalizedStringKey {
  var stringKey: String {
    let description = "\(self)"

    let components = description.components(separatedBy: "key: \"")
      .map { $0.components(separatedBy: "\",") }

    return components[1][0]
  }
}

extension String {
  static func localizedString(for key: String,
                              locale: Locale = .current) -> String {

    let language = locale.languageCode
    if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
      let bundle = Bundle(path: path)!
      let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

      return localizedString
    }

    return key
  }
}

extension LocalizedStringKey {
  func stringValue(locale: Locale = .current) -> String {
    return .localizedString(for: self.stringKey, locale: locale)
  }
}
