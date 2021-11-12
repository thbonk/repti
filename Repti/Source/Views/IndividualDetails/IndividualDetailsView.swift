//
//  IndividualDetailsView.swift
//  Repti
//
//  Created by Thomas Bonk on 02.11.21.
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

struct IndividualDetailsView: View {

  // MARK: - Public Properties

  var body: some View {
    ScrollView {
      VStack {
        GeneralDataSubview(individual: $individual)
        DatesSubview(individual: $individual)
        WeighingsSubview(individual: $individual)
        DocumentsSubview(individual: $individual)

        Spacer()
      }
    }
    .navigationTitle(individual.name!)
    .padding(15)
  }

  @Binding
  var individual: Individual
}

