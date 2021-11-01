//
//  AlertContentView.swift
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

import SwiftUI

struct AlertContentView: View {

  // MARK: - Public Properties

  var body: some View {
    VStack {
      Text(alertTitle())
        .font(.title)
        .padding(.vertical, 20)
        .padding(.horizontal, 50)

      HStack {
        AlertImage()

        VStack {
          Text(message.stringValue())

          if let err = error {
            Text("Fehler:\n \(err.localizedDescription)")
              .padding(.top, 5)
          }
        }
        .padding(.horizontal, 20)
      }
      .padding(.horizontal, 20)

      Button {
        presentationMode.wrappedValue.dismiss()
      } label: {
        Text("OK")
          .padding(.horizontal, 50)
      }
      .padding(.top, 20)
      .padding(.bottom, 10)
      .buttonStyle(BorderedProminentButtonStyle())
    }
    /*VStack(alignment: .center) {
      HStack(alignment: .center) {
        AlertImage()

        VStack(alignment: .leading) {
          Text(message)

          /*if let err = error {
            Text("Fehler: \(err.localizedDescription)")
              .padding(.top, 5)
          }*/
        }
      }

      Button {
        presentationMode.wrappedValue.dismiss()
      } label: {
        Text("OK")
      }
    }*/
  }

  var alertType: AlertData.`Type`
  var message: LocalizedStringKey
  var error: Error?


  // MARK: - Private Properties

  @Environment(\.presentationMode)
  var presentationMode


  // MARK: - Private Methods

  private func alertTitle() -> LocalizedStringKey {
    switch alertType {
      case .information:
        return "Information"

      case .warning:
        return "Warnung"

      case .error:
        return "Fehler"

      case .fatalError:
        return "Schwerer Fehler"
    }
  }

  private func AlertImage() -> some View {
    var image: Image
    var color: Color

    switch alertType {
      case .information:
        image = Image(systemName: "info.circle.fill")
        color = .green
        break

      case .warning:
        image = Image(systemName: "exclamationmark.triangle.fill")
        color = .yellow
        break

      case .error:
        image = Image(systemName: "exclamationmark.octagon.fill")
        color = .red
        break

      case .fatalError:
        image = Image(systemName: "xmark.octagon.fill")
        color = .red
        break
    }

    return image.resizable().frame(width: 64, height: 64).foregroundColor(color)
  }
}

