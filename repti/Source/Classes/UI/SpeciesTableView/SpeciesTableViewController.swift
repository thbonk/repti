//
//  SpeciesTableViewController.swift
//  Repti
//
//  Created by Thomas Bonk on 04.01.21.
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
import SwiftUI

class SpeciesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  // MARK: - Private Properties

  private let persistentContainer = resolve(PersistentContainer.self)
  private var fetchedResultsController: NSFetchedResultsController<Species>!
  private var speciesHeaderViews: [Int:SpeciesHeaderView] = [:]


  // MARK: - Initialization

  override func awakeFromNib() {
    let speciesFetchRequest = NSFetchRequest<Species>(entityName: Species.entityName)

    speciesFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

    fetchedResultsController =
      NSFetchedResultsController(
                fetchRequest: speciesFetchRequest,
        managedObjectContext: (persistentContainer?.container.viewContext)!,
          sectionNameKeyPath: nil,
                   cacheName: nil)
    fetchedResultsController.delegate = self
  }


  // MARK: - UIViewController

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    do {
      try fetchedResultsController.performFetch()
    } catch {

    }
  }


  // MARK: - UITableVewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSpecies()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return
      (speciesHeaderViews[section]?.isExpanded ?? false)
      ? numberOfIndividuals(forSpeciesIndex: section)
      : 0
  }


  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let species = speciesAt(index: section)!

    guard let view = speciesHeaderViews[section] else {
      let view =
        SpeciesHeaderView
        .loadView(
          for: species,
          deleteHandler: self.delete(species:),
          editHandler: self.edit(species:))

      speciesHeaderViews[section] = view
      return view
    }

    view.species = species
    return view
  }


  // MARK: - Private Methods

  private func speciesAt(index: Int) -> Species? {
    guard numberOfSpecies() > 0 else {
      return nil
    }

    return (fetchedResultsController.sections![0].objects as! [Species])[index]
  }

  private func numberOfSpecies() -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }

    guard sections.count > 0 else {
      return 0
    }

    return sections[0].numberOfObjects
  }

  private func numberOfIndividuals(forSpeciesIndex section: Int) -> Int {
    guard numberOfSpecies() > 0 else {
      return 0
    }

    guard let individuals = speciesAt(index: section)?.individuals else {
      return 0
    }

    return individuals.count
  }

  private func reloadSections(_ indexSet: IndexSet) {
    UIView
      .transition(with: self.tableView, duration: 0.01, options: .transitionCrossDissolve, animations: {
        self
          .tableView
          .reloadSections(indexSet, with: .automatic)
      }, completion: nil)
  }


  // MARK: - Action Handlers

  @IBAction
  private func delete(species: Species) {

  }

  @IBAction
  private func edit(species: Species) {
    let speciesEditorView = SpeciesEditorView(mode: .edit, model: SpeciesDAO(species: species))
    let hostingController = UIHostingController(rootView: speciesEditorView)

    hostingController.rootView.cancelAction = {
      hostingController.dismiss(animated: true)
    }
    hostingController.rootView.saveAction = { model in
      do {
        species.name = model.name
        species.scientificName = model.scientificName
        try self.persistentContainer!.saveContext()
        DispatchQueue.main.async {
          self.speciesHeaderViews.removeAll()
        }
        DispatchQueue.main.async {
          try! self.fetchedResultsController.performFetch()
        }
        DispatchQueue.main.async {
          self.reloadSections(IndexSet(IndexPath(indexes: Array(0...self.fetchedResultsController.sections!.count))))
        }
      } catch {
        AppDelegate
          .error(
            self,
            message: NSLocalizedString("Error while saving changed species.", comment: "Error Message"),
            error: error)
      }
      hostingController.dismiss(animated: true)
    }

    hostingController.preferredContentSize = CGSize(width: 350,height: 270)
    hostingController.modalPresentationStyle = .formSheet
    present(hostingController, animated: true)
  }

  @IBAction
  private func addSpecies(_ sender: UIBarButtonItem) {
    let speciesEditorView = SpeciesEditorView(mode: .create)
    let hostingController = UIHostingController(rootView: speciesEditorView)

    hostingController.rootView.cancelAction = {
      hostingController.dismiss(animated: true)
    }
    hostingController.rootView.saveAction = { model in
      self.createSpecies(species: model)
      hostingController.dismiss(animated: true)
    }

    hostingController.preferredContentSize = CGSize(width: 350,height: 270)
    hostingController.modalPresentationStyle = .formSheet
    present(hostingController, animated: true)
  }

  private func createSpecies(species: SpeciesDAO) {
    let speciesObject = Species.create(in: persistentContainer!.container.viewContext)

    speciesObject.name = species.name
    speciesObject.scientificName = species.scientificName

    do {
      try persistentContainer!.saveContext()
    } catch {
      AppDelegate
        .error(
          self,
          message: NSLocalizedString("Error while saving new species.", comment: "Error Message"),
          error: error)
    }
  }
}
