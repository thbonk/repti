//
//  GeneralDataSubview.swift
//  Repti
//
//  Created by Thomas Bonk on 14.04.21.
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

import PureSwiftUI

struct GeneralDataSubview: View {

  // MARK: - Public Properties

  @Binding
  var individual: Individual

  var body: some View {
    // Name and Gender
    VStack(alignment: .leading) {
      HStack {
        Text("Name:").font(.headline)
        TextField("Enter Name", text: $individual.name)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.trailing, 10)
        Text("Gender:").font(.headline)
        Picker(selection: $individual.genderVal, label: Text("Gender")) {
          ForEach(Gender.allCases) { gender in
            Text(gender.displayName).tag(gender.rawValue)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
    }.padding(.vertical, 10)
  }
}


// MARK: - Preview

struct GeneralDataSubview_Previews: PreviewProvider {
  static var previews: some View {
    GeneralDataSubview(individual: Binding(get: { Individual() }, set: { _ in }))
  }
}
