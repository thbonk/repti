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

import UIKit
import CoreData

private extension String {
  static var CellId = "SpeciesCellId"
  static var ShowIndividualsForSpecies = "ShowIndividualsForSpecies"
}

class SpeciesViewController
  : UITableViewController,
    NSFetchedResultsControllerDelegate {

  // MARK: - Private Properties

  private var store = AppDelegate.shared.container.resolve(CoreDataStore.self)
  private var fetchedResultsController: NSFetchedResultsController<Species>!


  // MARK: - Initialization

  override func awakeFromNib() {
    super.awakeFromNib()
    
    fetchedResultsController =
      NSFetchedResultsController(
                fetchRequest: AppDelegate.shared.container.resolve(NSFetchRequest<Species>.self)!,
        managedObjectContext: store!.persistentContainer.viewContext,
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
      AppDelegate
        .fatalError(
          message: NSLocalizedString("Error while loading species", comment: "Error Message"),
          error: error)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == .ShowIndividualsForSpecies {
      let individualsViewController = segue.destination as? IndividualsViewController

      individualsViewController?.species = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
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
    let species = fetchedResultsController.object(at: indexPath)

    cell.textLabel?.text = species.name
    cell.detailTextLabel?.text = species.scientificName

    return cell
  }

  override func tableView(
                                            _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    let actionsConfiguration =
      UISwipeActionsConfiguration(
        actions: [
          UIContextualAction(style: .normal, title: "Edit", handler: { (action, view, completed) in
            let species = self.fetchedResultsController.object(at: indexPath)

            SpeciesEditorController
              .present(
                for: self,
                mode: .edit,
                species: species,
                onSave: self.save(species:),
                onCancel: self.cancelChange(species:))
            completed(true)
          }),
          UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completed) in
            do {
              let species = self.fetchedResultsController.object(at: indexPath)

              self.store?.persistentContainer.viewContext.delete(species)
              try self.store?.saveContext()
              completed(true)
            } catch {
              AppDelegate
                .error(
                  self,
                  message: NSLocalizedString("Error while deleting species.", comment: "Error Message"),
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
      } else if let path = fetchedResultsController.indexPath(forObject: anObject as! Species) {
        tableView.deleteRows(at: [path], with: .automatic)
      }
      break;

    case .insert:
      if let path = indexPath {
        tableView.insertRows(at: [path], with: .automatic)
      } else if let path = fetchedResultsController.indexPath(forObject: anObject as! Species) {
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
      } else if let path = fetchedResultsController.indexPath(forObject: anObject as! Species) {
        tableView.reloadRows(at: [path], with: .automatic)
      }
      break;

    @unknown default:
      break;
    }
  }


  // MARK: - Action Handlers

  @IBAction func addSpecies(sender: UIBarButtonItem) {
    let species: SpeciesProtocol = SpeciesDAO()

    SpeciesEditorController
      .present(
             for: self,
         species: species,
          onSave: self.add(species:),
        onCancel: self.cancelChange(species:))
  }

  private func add(species: SpeciesProtocol?) {
    do {
      let entity = Species.create(in: store!.persistentContainer.viewContext)

      entity.name = species!.name
      entity.scientificName = species!.scientificName
      entity.individuals = species!.individuals

      try store?.saveContext()
    } catch {
      AppDelegate
        .error(
          self,
          message: NSLocalizedString("Error while saving species.", comment: "Error Message"),
            error: error)
    }
  }

  private func save(species: SpeciesProtocol?) {
    do {
      try store?.saveContext()
    } catch {
      AppDelegate
        .error(
          self,
          message: NSLocalizedString("Error while saving species.", comment: "Error Message"),
          error: error)
    }
  }

  private func cancelChange(species: SpeciesProtocol?) {
    store?.rollbackContext()
  }
}

