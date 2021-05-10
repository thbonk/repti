//
//  DocumentsSubview.swift
//  Repti
//
//  Created by Thomas Bonk on 06.05.21.
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
import UniformTypeIdentifiers
import SwiftUILib_DocumentPicker

struct DocumentsSubview: View {

  // MARK: - Public Properties
  
  var body: some View {
    DisclosureGroup(isExpanded: $expanded, content: {
      RenderIf((individual.documents?.count ?? 0) > 0) {
        VStack(alignment: .leading) {
          LazyVGrid(columns: [GridItem(), GridItem()]) {
            Text("Filename").fontWeight(.bold)
            Text("Date").fontWeight(.bold)
            Text("Notes").fontWeight(.bold)
          }
          List {
            let dateFormatter = dateFormatter()

            ForEach(Array(individual.documents!).sorted(by: dateDescending), id: \.id) { document in
              LazyVGrid(columns: [GridItem(), GridItem()]) {
                Text(document.filename!)
                Text(dateFormatter.string(from: document.date!))
                Text(document.notes!)
              }
              .contextMenu {
                Button {
                  
                } label: {
                  HStack {
                    Image(systemName: "square.and.pencil")
                    Text(LocalizedStringKey("Edit"))
                  }
                }
              }
            }
          }
          .frame(minHeight: 0, maxHeight: .infinity)
        }
      }.elseRender {
        Text(LocalizedStringKey("No documents available"))
      }
    }) {
      HStack {
        Text(LocalizedStringKey("Documents")).font(.title)
        .documentPicker(
          isPresented: $showFileImporter,
          documentTypes: ["org.openxmlformats.wordprocessingml.document", "com.adobe.pdf"]) {

        } onDocumentsPicked: { urls in
          NSLog("\(urls)")
        }
        Spacer()
        Button {
          showFileImporter = false
          // fix broken picker sheet
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showFileImporter = true
          }
        } label: {
          Image(systemName: "doc.badge.plus")
            .padding(.horizontal, 10)
        }
        .disabled(!expanded)

        /*.fileImporter(
                      isPresented: $showFileImporter,
              allowedContentTypes: [.data],
          allowsMultipleSelection: false) { result in
                      // add fileUrl.startAccessingSecurityScopedResource() before accessing file
            NSLog("\(result)")
          }*/
      }
    }
  }

  @Binding
  var individual: Individual

  @Binding
  var expanded: Bool


  // MARK: - Private Properties

  @State
  private var showFileImporter = false



  // MARK: Private Methods

  private func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none

    return formatter
  }

  private func dateDescending(_ doc1: Document, _ doc2: Document) -> Bool {
    return doc1.date! < doc2.date!
  }
}

struct DocumentsSubview_Previews: PreviewProvider {
  static var previews: some View {
    DocumentsSubview(
      individual: Binding(get: {
        Individual()
      }, set: { _ in

      }),
      expanded: Binding(get: {
        true
      }, set: { _ in
        
      }))
  }
}
