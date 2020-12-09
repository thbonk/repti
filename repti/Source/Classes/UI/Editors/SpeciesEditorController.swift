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

class SpeciesEditorController: FormViewController {

  enum Mode {
    case add
    case edit
  }

  // MARK: - Private Properties

  @IBOutlet var titleBar: UINavigationItem!
  @IBOutlet var saveButton: UIBarButtonItem!

  private var mode: Mode = .add
  private var species: SpeciesProtocol? = nil
  private var speciesNameValid = false
  private var speciesScientificNameValid = false
  private var onSave: ((SpeciesProtocol?) -> Void)? = nil
  private var onCancel: ((SpeciesProtocol?) -> Void)? = nil


  // MARK: - Class Methods

  class func present(
    for viewController: UIViewController,
                  mode: Mode = .add,
               species: SpeciesProtocol? = nil,
                onSave: ((SpeciesProtocol?) -> Void)? = nil,
              onCancel: ((SpeciesProtocol?) -> Void)? = nil) {

    let speciesEditorController = StoryboardScene.Main.speciesEditorController.instantiate()
    speciesEditorController.modalPresentationStyle = .formSheet

    speciesEditorController.mode = mode
    speciesEditorController.species = species
    speciesEditorController.onSave = onSave
    speciesEditorController.onCancel = onCancel

    viewController.present(speciesEditorController, animated: true, completion: nil)
  }


  // MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()

    form
      +++ Section(NSLocalizedString("Name", comment: "Form Section Title"))
        <<< TextRow(){ row in
          row.placeholder = NSLocalizedString("Enter name here", comment: "Textfield Placeholder")
          row.value = species?.name
          row.validationOptions = .validatesOnChange
          row.add(rule: RuleRequired(msg: NSLocalizedString("Name is required", comment: "Error Message")))
          row.onChange { row in
            self.species?.name = row.value ?? ""
          }
          row.onRowValidationChanged { (cell, row) in
            // TODO
            self.speciesNameValid = row.isValid
            self.invalidateSaveButton()
          }
          row.validate()
        }
      +++ Section(NSLocalizedString("Scientific Name", comment: "Form Section Title"))
        <<< TextRow(){ row in
          row.placeholder = NSLocalizedString("Enter scientific name here", comment: "Textfield Placeholder")
          row.value = species?.scientificName
          row.validationOptions = .validatesOnChange
          row.add(rule: RuleRequired(msg: NSLocalizedString("Scientific Name is required", comment: "Error Message")))
          row.onChange { row in
            self.species?.scientificName = row.value ?? ""
          }
          row.onRowValidationChanged { (cell, row) in
            // TODO
            self.speciesScientificNameValid = row.isValid
            self.invalidateSaveButton()
          }
          row.validate()
        }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    titleBar.title =
      (mode == .add)
      ? NSLocalizedString("Add Species", comment: "Navigation Item Title")
      : NSLocalizedString("Edit Species", comment: "Navigation Item Title")
  }


  // MARK: - Action Handlers

  @IBAction private func dismissEditor(sender: Any) {
    DispatchQueue.main.async {
      self.onCancel?(self.species)
    }

    dismiss(animated: true)
  }

  @IBAction private func saveSpecies(sender: Any) {
    DispatchQueue.main.async {
      self.onSave?(self.species)
    }

    dismiss(animated: true)
  }


  // MARK: - Private Methods

  private func invalidateSaveButton() {
    DispatchQueue.main.async {
      self.saveButton.isEnabled = self.speciesNameValid && self.speciesScientificNameValid
    }
  }
}
