//
//  IndividualRowView.swift
//  Repti
//
//  Created by Thomas Bonk on 11.04.21.
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

struct IndividualRowView: View {

  // MARK: - Public Properties

  @ObservedObject
  public var individual: Individual

  public var body: some View {
    LazyVGrid(
      columns: [GridItem(alignment: .leading), GridItem(alignment: .trailing)],
      content: {
        Text(individual.name)
          .font(.headline)
        Text(individual.gender.displayName)
          .font(.subheadline)
      })
  }
}

struct IndividualRowView_Previews: PreviewProvider {
  static var previews: some View {
    IndividualRowView(individual: Individual())
  }
}
