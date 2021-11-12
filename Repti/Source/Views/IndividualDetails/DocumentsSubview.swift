//
//  DocumentsSubview.swift
//  Repti
//
//  Created by Thomas Bonk on 08.11.21.
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

import Combine
import PureSwiftUI
import SwiftUI
import UniformTypeIdentifiers

struct DocumentsSubview: View {

  // MARK: - Public Properties

  var body: some View {
    VStack(alignment: .leading) {
      Divider()
      SubviewHeader()
        .padding(.bottom, 10)
      DocumentList()
    }
    .padding(.vertical, 20)
    .fileImporter(
      isPresented: $showFileImporter,
      allowedContentTypes: [UTType.pdf, UTType.rtf, UTType.openXml]) { result in
          if case let .success(url) = result {
            createDocument(with: url)
          }
      }
      .sheet(isPresented: $showDocumentEditor) {
        DocumentEditorView(
          document: editDocument.value?.document,
               url: editDocument.value?.url,
              mode: editDocument.value!.mode,
            onSave: save(url:date:notes:),
          onCancel: cancel)
      }
  }

  @Binding
  var individual: Individual


  // MARK: - Private Properties

  @Environment(\.managedObjectContext)
  private var viewContext

  @State
  private var showFileImporter: Bool = false
  @State
  private var showDocumentEditor: Bool = false
  @State
  private var selectedDocument: Document?
  @State
  private var previewOpen: Bool = false
  @State
  private var previewOpenCancellable: AnyCancellable? = nil

  @ObservedObject
  private var editDocument = ValueWrapper<(document: Document?, url: URL?, mode: DocumentEditorView.Mode)>()


  // MARK: - Private Methods

  private func SubviewHeader() -> some View {
    return
      HStack(alignment: .center) {
        Text("Dokumente").bold()
        Spacer()
        Button(action: { showFileImporter = true }, label: { SFSymbol(.doc_badge_plus) })
          .padding(.trailing, 10)
        Button(action: editDocumentInfo, label: { SFSymbol(.square_and_pencil) })
          .padding(.trailing, 10)
          .disabled(selectedDocument == nil)
        Button(action: deleteDocument, label: { SFSymbol(.trash_square_fill) })
          .padding(.trailing, 10)
          .disabled(selectedDocument == nil)
      }
      .buttonStyle(BorderlessButtonStyle())
  }

  private func DocumentList() -> some View {
    return VStack(alignment: .leading) {
      ForEach(Array(individual.documents!).sorted(by: dateDescending), id: \.id) { document in
        VStack(alignment: .leading) {
          HStack {
            Text(document.filename!)
            Spacer().frame(minWidth: 64)
            Text(weighingDateFormatter.string(from: document.date!))
          }
          Text(document.notes!)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .padding(.top, 3)
        }
        .padding(.all, 10)
        .gesture(TapGesture(count: 2).onEnded {
          // double click
          guard !previewOpen else { return }
          selectedDocument = document
          openDocument()
        })
        .simultaneousGesture(TapGesture().onEnded {
          // single click
          guard !previewOpen else { return }
          selectedDocument = document
        })
        .backgroundIf(selectedDocument == document, Color.accentColor).cornerRadius(5)
      }
      .padding(.all, 10)
      }
  }

  private func createDocument(with url: URL) {
    editDocument.value = (document: nil, url: url, mode: .create)
    showDocumentEditor = true
  }

  private func editDocumentInfo() {
    editDocument.value = (document: selectedDocument, url: nil, mode: .edit)
    showDocumentEditor = true
  }

  private func deleteDocument() {
    do {
      viewContext.delete(selectedDocument!)
      try viewContext.save()

      DispatchQueue.main.async {
        self.selectedDocument = nil
      }
    } catch {
      errorAlert(
        message: "Fehler beim Löschen des Dokuments.",
        error: error)
    }

  }

  private func openDocument() {
    do {
      let temporaryFileURL =
        URL(fileURLWithPath: NSTemporaryDirectory())
          .appendingPathComponent(selectedDocument!.filename!)

      try selectedDocument!.data!.data?.write(to: temporaryFileURL)

      let preview = QuickLookPreview(url: temporaryFileURL)
      preview.show()
      previewOpenCancellable = preview.$previewOpen.sink(receiveValue: previewVisibilityChanged)
    } catch {
      errorAlert(
        message: "Fehler beim öffnen des Dokuments.",
        error: error)
    }
  }

  private func previewVisibilityChanged(_ visible: Bool) {
    previewOpen = visible

    if !visible && previewOpenCancellable != nil {
      previewOpenCancellable?.cancel()
      previewOpenCancellable = nil
    }
  }

  private func save(url: URL?, date: Date, notes: String) {
    do {
      if let doc = editDocument.value?.document {
        doc.date = date
        doc.notes = notes
      } else {
        let doc = Document.create(in: viewContext)
        doc.filename = url!.lastPathComponent
        doc.date = date
        doc.notes = notes
        doc.individual = individual
        individual.addToDocuments(doc)

        let docData = DocumentData.create(in: viewContext)
        docData.document = doc
        docData.data = try Data(contentsOf: url!)
        doc.data = docData
      }

      try viewContext.save()
    } catch {
      errorAlert(
        message: "Fehler beim Speichern der Daten.",
        error: error)
    }
  }

  private func cancel() {
    viewContext.rollback()
  }

  private func dateDescending(_ doc1: Document, _ doc2: Document) -> Bool {
    return doc1.date! < doc2.date!
  }
}

