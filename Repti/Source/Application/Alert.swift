//
//  Alert.swift
//  Repti
//
//  Created by Thomas Bonk on 31.10.21.
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

extension Notification.Name {
  static let showAlert = Notification.Name("ShowAlert")
}

struct AlertData {

  // MARK: - Enums

  enum `Type` {
    case information
    case warning
    case error
    case fatalError
  }

  // MARK: - Properties

  var type: `Type`
  var message: LocalizedStringKey
  var error: Error?
  var dismissCallback: () -> ()


  // MARK: - Initialization

  init(
    toastType: `Type`,
    message: LocalizedStringKey,
    error: Error? = nil,
    autohideIn: Double = 2.0,
    dismissCallback: @escaping () -> () = {}) {

    self.type = toastType
    self.message = message
    self.error = error
    self.dismissCallback = dismissCallback
  }
}

fileprivate func showAlert(data: AlertData) {
  NotificationCenter.default.post(Notification(name: .showAlert, alertData: data))
}

func informationAlert(message: LocalizedStringKey, dismissCallback callback: (() -> ())? = nil) {
  showAlert(data: AlertData(toastType: .information, message: message, dismissCallback: callback ?? {}))
}

func warningAlert(message: LocalizedStringKey, dismissCallback callback: (() -> ())? = nil) {
  showAlert(data: AlertData(toastType: .warning, message: message, dismissCallback: callback ?? {}))
}

func errorAlert(message: LocalizedStringKey, error: Error, dismissCallback callback: (() -> ())? = nil) {
  showAlert(data: AlertData(toastType: .error, message: message, error: error, dismissCallback: callback ?? {}))
}

func fatalErrorAlert(message: LocalizedStringKey, error: Error) {
  showAlert(
    data:
      AlertData(
              toastType: .fatalError,
                message: message,
                  error: error,
        dismissCallback: { fatalError("\(message). Error: \(error)") }))
}

extension Notification {
  init(name: Notification.Name, alertData: AlertData) {
    self.init(name: name, object: nil, userInfo: ["alertData" : alertData])
  }

  var alertData: AlertData? {
    if let data = self.userInfo?["alertData"] as? AlertData {
      return data
    }

    return nil
  }
}
