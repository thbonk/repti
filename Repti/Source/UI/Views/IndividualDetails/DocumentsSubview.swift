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
          LazyVGrid(columns: [
                      GridItem(alignment: .leading),
                      GridItem(alignment: .leading),
                      GridItem(alignment: .leading)]) {
            
            Text("Filename").fontWeight(.bold)
            Text("Date").fontWeight(.bold)
            Text("Notes").fontWeight(.bold)
          }
          .padding(.all, 10)
          List {
            let dateFormatter = dateFormatter()
            
            ForEach(Array(individual.documents!).sorted(by: dateDescending), id: \.id) { document in
              LazyVGrid(columns: [
                          GridItem(alignment: .leading),
                          GridItem(alignment: .leading),
                          GridItem(alignment: .leading)]) {
                
                Text(document.filename!)
                Text(dateFormatter.string(from: document.date!))
                Text(document.notes!)
              }
              .padding(.all, 10)
              .backgroundIf(document.isEqual(selectedDocument), Color.accentColor)
              // This is a little bit hacky, but otherwise doesn't work reliably
              .onHover { hovering in
                guard hovering else { return }
                selectedDocument = document
              }
              .contextMenu {
                Button {
                  openDocument()
                } label: {
                  HStack {
                    Image(systemName: "doc.text.viewfinder")
                    Text(LocalizedStringKey("Open"))
                  }
                }
                Button {
                  editDocument.value =
                    (document: selectedDocument, dao: DocumentDAO(document: selectedDocument), mode: .edit)
                  showDocumentEditor = true
                } label: {
                  HStack {
                    Image(systemName: "square.and.pencil")
                    Text(LocalizedStringKey("Edit"))
                  }
                }
                Button {
                  delete(document: selectedDocument)
                } label: {
                  HStack {
                    Image(systemName: "trash.circle")
                    Text(LocalizedStringKey("Delete"))
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
            showFileImporter = false
          } onDocumentsPicked: { urls in
            showFileImporter = false
            createDocument(for: urls[0])
          }
        Spacer()
        Button {
          showFileImporter = true
        } label: {
          Image(systemName: "doc.badge.plus")
            .padding(.horizontal, 10)
        }
        .disabled(!expanded)
      }
      .padding(.vertical, 10)
      .sheet(isPresented: $showDocumentEditor) {
        DocumentEditorView(
          document: editDocument.value!.dao,
          mode: editDocument.value!.mode,
          onSave: save(document:),
          onDismiss: {
            editDocument.value = nil
          })
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
  
  @State
  private var showDocumentEditor = false
  
  @State
  private var editDocument = OptionalValue<(document: Document?, dao: DocumentDAO, mode: DocumentEditorView.Mode)>()
  
  @State
  private var selectedDocument: Document!
  
  @Environment(\.managedObjectContext)
  private var viewContext
  
  
  // MARK: Private Methods
  
  private func createDocument(for url: URL) {
    let filePath = url.path
    let fileAttrs = try? FileManager.default.attributesOfItem(atPath: filePath)
    let document =
      DocumentDAO(
        date: fileAttrs![.creationDate] as! Date,
        filename: url.lastPathComponent,
        fileURL: url)
    
    editDocument.value = (document: nil, dao: document, mode: .create)
    showDocumentEditor = true
  }
  
  private func save(document: DocumentDAO) throws {
    if let doc = editDocument.value!.document {
      doc.date = document.date
      doc.filename = document.filename
      doc.notes = document.notes
    } else {
      let doc = Document.create(in: viewContext)
      
      doc.date = document.date
      doc.filename = document.filename
      doc.notes = document.notes
      
      doc.individual = individual
      
      let docData = DocumentData.create(in: viewContext)
      docData.document = doc
      
      let data = try Data(contentsOf: document.fileURL!)
      docData.data = data
      doc.documentData = docData
    }
    
    editDocument.value = nil
    
    try viewContext.save()
  }
  
  private func delete(document: Document) {
    do {
      viewContext.delete(document)
      try viewContext.save()
    } catch {
      errorAlert(
        message: "Error while deleting a document.",
        error: error)
    }
  }
  
  private func openDocument() {
    do {
      let temporaryFileURL =
        URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(selectedDocument.filename!)
      
      try selectedDocument.documentData!.data?.write(to: temporaryFileURL)
      
      UIApplication
        .shared
        .open(
          temporaryFileURL,
          options: [.universalLinksOnly: false]) { success in
          guard success else {
            warningAlert(message: "Error while opneing the document '\(selectedDocument.filename!)'")
            return
          }
        }
    } catch {
      errorAlert(
        message: "Error while deleting a document.",
        error: error)
    }
  }
  
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
