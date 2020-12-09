/*
 Copyright 2020 Thomas Bonk <thomas@meandmymac.de>

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import UIKit
import CoreData
import SwiftEventBus

 private extension String {
  static let CellId = "IndividualCellId"
 }

public extension String {
  static let IndividualSelected = "IndividualSelected"
  static let IndividualDeselected = "IndividualDeselected"
}

class IndividualsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

  // MARK: - Public Properties

  var species: Species!


  // MARK: - Private Properties

  private var store = AppDelegate.shared.container.resolve(CoreDataStore.self)
  private var fetchedResultsController: NSFetchedResultsController<Individual>!


  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchedResultsController =
      NSFetchedResultsController(
        fetchRequest: AppDelegate.shared.container.resolve(NSFetchRequest<Individual>.self, argument: species)!,
        managedObjectContext: store!.persistentContainer.viewContext,
        sectionNameKeyPath: nil,
        cacheName: nil)
    fetchedResultsController.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationItem.title = species.name

    do {
      try fetchedResultsController.performFetch()
    } catch {
      AppDelegate
        .fatalError(
          message: NSLocalizedString("Error while loading species", comment: "Error Message"),
          error: error)
    }
  }


  // MARK: - UITableViewDataSource

  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: .CellId, for: indexPath)
    let individual = fetchedResultsController.object(at: indexPath)

    cell.textLabel?.text = individual.name
    cell.textLabel?.adjustsFontSizeToFitWidth = true
    cell.detailTextLabel?.text = individual.gender.displayName
    cell.detailTextLabel?.adjustsFontSizeToFitWidth = true

    return cell
  }

  override func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    let actionsConfiguration =
      UISwipeActionsConfiguration(
        actions: [
          UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completed) in
            do {
              let individual = self.fetchedResultsController.object(at: indexPath)

              self.store?.persistentContainer.viewContext.delete(individual)
              try self.store?.saveContext()
              completed(true)
            } catch {
              AppDelegate
                .error(
                  self,
                  message: NSLocalizedString("Error while deleting individual.", comment: "Error Message"),
                  error: error)
              completed(false)
            }
          }),
        ]) // T##[UIContextualAction])

    return actionsConfiguration
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }


  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let individual = fetchedResultsController.object(at: indexPath)

    SwiftEventBus.post(.IndividualSelected, sender: individual)
  }

  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    SwiftEventBus.post(.IndividualDeselected)
  }


  // MARK: - NSFetchedResultsControllerDelegate

  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }

  func controller(
          _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
          at indexPath: IndexPath?,
              for type: NSFetchedResultsChangeType,
          newIndexPath: IndexPath?) {

    switch type {
    case .delete:
      if let path = indexPath {
        tableView.deleteRows(at: [path], with: .automatic)
      } else if let path = fetchedResultsController.indexPath(forObject: anObject as! Individual) {
        tableView.deleteRows(at: [path], with: .automatic)
      }
      break;

    case .insert:
      if let path = indexPath {
        tableView.insertRows(at: [path], with: .automatic)
      } else if let path = fetchedResultsController.indexPath(forObject: anObject as! Individual) {
        tableView.insertRows(at: [path], with: .automatic)
      }
      break;

    case .move:
      if let path = indexPath {
        tableView.moveRow(at: path, to: newIndexPath!)
      }
      break;

    case .update:
      if let path = indexPath {
        tableView.reloadRows(at: [path], with: .automatic)
      } else if let path = fetchedResultsController.indexPath(forObject: anObject as! Individual) {
        tableView.reloadRows(at: [path], with: .automatic)
      }
      break;

    @unknown default:
      break;
    }
  }


  // MARK: - Action Handlers

  @IBAction private func addIndividual(sender: UIBarButtonItem) {
    AddIndividualController.present(for: self, species: species, onSave: self.saveIndividual)
  }

  private func saveIndividual(_ individ: IndividualProtocol?) {
    do {
      let individual = Individual.create(in: store!.persistentContainer.viewContext)

      individual.species = species
      individual.name = individ!.name
      individual.gender = individ!.gender

      species.addToIndividuals(individual)

      try store?.saveContext()
    } catch {
      AppDelegate
        .error(
          self,
          message: NSLocalizedString("Error while saving individual.", comment: "Error Message"),
          error: error)
    }
  }
}
