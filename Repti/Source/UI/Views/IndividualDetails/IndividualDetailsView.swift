//
//  IndividualDetailsView.swift
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

struct IndividualDetailsView: View {

  // MARK: - Public Properties

  @Binding
  var individual: Individual

  var body: some View {
    Form {
      GeneralDataSubview(individual: $individual)
      DatesSubview(individual: $individual, expanded: $datesExpanded)
      WeighingsSubview(individual: $individual, expanded: $weighingsExpanded)
      PicturesSubview(individual: $individual, expanded: $picturesExpanded)
      RenderIf(enableDocuments) {
        DocumentsSubview(individual: $individual, expanded: $documentsExpanded)
      }
    }
    .navigationBarTitle(individual.name)
  }


  // MARK: - Private Properties

  @State
  private var datesExpanded: Bool = true
  @State
  private var weighingsExpanded: Bool = true
  @State
  private var picturesExpanded: Bool = true
  @State
  private var documentsExpanded: Bool = true

  @Environment(\.repti_enable_documents)
  private var enableDocuments
}


// MARK: - Preview

struct IndividualDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    IndividualDetailsView(individual: Binding(get: { Individual() }, set: { _ in }))
  }
}
