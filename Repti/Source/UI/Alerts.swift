//
//  Alerts.swift
//  Repti
//
//  Created by Thomas Bonk on 06.01.21.
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

fileprivate func alert(
  title: String,
  message: String,
  handler: ((UIAlertAction) -> Void)? = nil) {

  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

  alert
    .addAction(
      UIAlertAction(
        title: NSLocalizedString("OK", comment: "Alert Controller Button"),
        style: .default,
        handler: handler))

  let controller = UIApplication.shared.windows.first!.rootViewController!
  controller.present(alert, animated: true, completion: nil)
}

func fatalErrorAlert(message: String, error: Error) {
  alert(
    title: NSLocalizedString("Fatal Error", comment: "Alert Controller Title"),
    message: "\(message)\nApp will be terminated.\nError: \(error)",
    handler: { _ in fatalError("\(message)\nError: \(error)") })
}

func errorAlert(
  message: String,
  error: Error,
  handler: ((UIAlertAction) -> Void)? = nil) {

  alert(
    title: NSLocalizedString("Error", comment: "Alert Controller Title"),
    message: "\(message)\nError: \(error.localizedDescription)",
    handler: handler)
}
