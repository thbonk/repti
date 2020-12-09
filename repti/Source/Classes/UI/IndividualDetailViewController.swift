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
import Eureka
import SwiftEventBus

class IndividualDetailViewController: FormViewController {

  // MARK: - Public Properties

  var individual: Individual? = nil {
    didSet {
      adjustUI(individual != nil)
    }
  }


  // MARK: - Private Properties

  let store = AppDelegate.shared.container.resolve(CoreDataStore.self)


  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    SwiftEventBus.onMainThread(self, name: .IndividualSelected) { notification in
      self.individual = notification?.object as? Individual
    }

    adjustForm()
  }


  // MARK: - Private Methods

  private func adjustUI(_ speciesSelected: Bool) {
    navigationItem.title =
      individual?.name ?? NSLocalizedString("No Individual selected!", comment: "Navigation Item Title")

    adjustForm()
  }

  private func adjustForm() {
    if form.allRows.count > 0 {
      form.removeAll(keepingCapacity: true)
    }

    guard let individual = individual else {
      return
    }

    var ovipositionDate = individual.ovipositionDate
    var hatchingDate = individual.hatchingDate
    var purchasingDate = individual.purchasingDate
    var dateOfSale = individual.dateOfSale

    form
      +++ Section(NSLocalizedString("General Data", comment: "Form Section Title"))
      <<< makeRow(title: NSLocalizedString("Name", comment: "Label Title")) { (row: TextRow) in
        row.value = individual.name
      }.onChange { (row) in
        individual.name = row.value?.right ?? ""
        self.commit()
      }
      <<< makeRow(title: NSLocalizedString("Gender", comment: "Label Title")) { (row: SegmentedRow<Gender>) in
        row.options = [.male, .female, .unknown]
        row.displayValueFor = { gender in gender?.displayName }
        row.value = individual.gender
      }.onChange { row in
        individual.gender = row.value?.right ?? .unknown
        self.commit()
      }
      +++ Section(NSLocalizedString("Dates", comment: "Form Section Title"))
      <<< SplitRow<SplitRow<LabelRow, DateRow>, SplitRow<LabelRow, DateRow>>() { (row) in
        #warning("This must be handled differently for iPhone")
        row.rowLeftPercentage = 0.5

        row.rowLeft = makeRow(
                   title: NSLocalizedString("Ovipisition Date", comment: "Label Title"),
          leftPercentage: 0.5) { (row: DateRow) in

          row.value = individual.ovipositionDate
          row.onCellSelection  { (cell, row) in
            if row.isHighlighted {
              DatePickerController
                .present(
                  for: cell,
                  of: self,
                  date: individual.ovipositionDate,
                  onAccept: { date in
                    ovipositionDate = date
                    row.value = date
                  })
            }
          }
        }

        row.rowRight = makeRow(
                   title: NSLocalizedString("Hatching Date", comment: "Label Title"),
          leftPercentage: 0.5) { (row: DateRow) in

          row.value = individual.hatchingDate
          row.onCellSelection  { (cell, row) in
            if row.isHighlighted {
              DatePickerController
                .present(
                  for: cell,
                  of: self,
                  date: individual.hatchingDate,
                  onAccept: { date in
                    hatchingDate = date
                    row.value = date
                  })
            }
          }
        }
      }.onChange({ (row) in
        individual.ovipositionDate = ovipositionDate
        individual.hatchingDate = hatchingDate
        self.commit()
      })
      <<< SplitRow<SplitRow<LabelRow, DateRow>, SplitRow<LabelRow, DateRow>>() { (row) in
        #warning("This must be handled differently for iPhone")
        row.rowLeftPercentage = 0.5

        row.rowLeft = makeRow(
                   title: NSLocalizedString("Purchasing Date", comment: "Label Title"),
          leftPercentage: 0.5) { (row: DateRow) in

          row.value = individual.purchasingDate
          row.onCellSelection  { (cell, row) in
            if row.isHighlighted {
              DatePickerController
                .present(
                  for: cell,
                  of: self,
                  date: individual.purchasingDate,
                  onAccept: { date in
                    purchasingDate = date
                    row.value = date
                  })
            }
          }
        }

        row.rowRight = makeRow(
                   title: NSLocalizedString("Date of Sale", comment: "Label Title"),
          leftPercentage: 0.5) { (row: DateRow) in
          
          row.value = individual.dateOfSale
          row.onCellSelection  { (cell, row) in
            if row.isHighlighted {
              DatePickerController
                .present(
                  for: cell,
                  of: self,
                  date: individual.dateOfSale,
                  onAccept: { date in
                    dateOfSale = date
                    row.value = date
                  })
            }
          }
        }
      }
      .onChange({ (row) in
        individual.purchasingDate = purchasingDate
        individual.dateOfSale = dateOfSale
        self.commit()
      })
  }


  // MARK: - Private Methods

  private func makeRow<RT>(
             title: String,
    leftPercentage: CGFloat = 0.25,
       initializer: (RT) -> Void) -> SplitRow<LabelRow, RT> {

    return SplitRow<LabelRow, RT>() { row in
      row.rowLeftPercentage = leftPercentage

      row.rowLeft = LabelRow() { row in
        row.title = title
        row.cellStyle = .default
      }.cellUpdate { (cell, row) in
        cell.textLabel?.textAlignment = .right
      }

      row.rowRight = RT.init() { row in
        initializer(row)
      }
    }
  }

  private func commit() {
    do {
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
