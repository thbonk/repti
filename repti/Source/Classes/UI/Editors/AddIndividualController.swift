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

class AddIndividualController: FormViewController {

  // MARK: - Private Properties

  @IBOutlet var saveButton: UIBarButtonItem!

  private var species: Species!
  private var individual: IndividualDAO!
  private var individualNameValid = false
  private var onSave: ((IndividualProtocol) -> Void)? = nil
  private var onCancel: ((IndividualProtocol) -> Void)? = nil


  // MARK: - Class Methods

  class func present(
    for viewController: UIViewController,
               species: Species,
                onSave: ((IndividualProtocol?) -> Void)? = nil,
              onCancel: ((IndividualProtocol?) -> Void)? = nil) {

    let addIndividualController = StoryboardScene.Main.addIndividualController.instantiate()
    addIndividualController.modalPresentationStyle = .formSheet

    addIndividualController.species = species
    addIndividualController.individual = IndividualDAO(species: species)
    addIndividualController.onSave = onSave
    addIndividualController.onCancel = onCancel

    viewController.present(addIndividualController, animated: true, completion: nil)
  }


  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    form
      +++ Section(NSLocalizedString("Species", comment: "Form Section Title"))
      <<< LabelRow(){ row in
        row.title = NSLocalizedString("Name", comment: "Label Title")
        row.value = species?.name
      }
      <<< LabelRow(){ row in
        row.title = NSLocalizedString("Scientific Name", comment: "Label Title")
        row.value = species?.scientificName
      }
      +++ Section(NSLocalizedString("Name", comment: "Form Section Title"))
      <<< TextRow() { row in
        row.placeholder = NSLocalizedString("Enter name here", comment: "Textfield Placeholder")
        row.value = individual.name
        row.validationOptions = .validatesOnChange
        row.add(rule: RuleRequired(msg: NSLocalizedString("Name is required", comment: "Error Message")))
        row.onChange { row in
          self.individual.name = row.value ?? ""
        }
        row.onRowValidationChanged { (cell, row) in
          // TODO
          self.individualNameValid = row.isValid
          self.invalidateSaveButton()
        }
        row.validate()
      }
      +++ Section(NSLocalizedString("Gender", comment: "Form Section Title"))
      <<< SegmentedRow<Gender>() { row in
        row.options = [.male, .female, .unknown]
        row.displayValueFor = { gender in gender?.displayName }
        row.value = individual.gender
        row.onChange { row in
          self.individual.gender = row.value ?? .unknown
        }
      }

    tableView.isEditing = false
  }


  // MARK: - Action Handlers

  @IBAction private func dismissEditor(sender: Any) {
    DispatchQueue.main.async {
      self.onCancel?(self.individual)
    }

    dismiss(animated: true)
  }

  @IBAction private func saveSpecies(sender: Any) {
    DispatchQueue.main.async {
      self.onSave?(self.individual)
    }

    dismiss(animated: true)
  }


  // MARK: - Private Methods

  private func invalidateSaveButton() {
    DispatchQueue.main.async {
      self.saveButton.isEnabled = self.individualNameValid
    }
  }
}

