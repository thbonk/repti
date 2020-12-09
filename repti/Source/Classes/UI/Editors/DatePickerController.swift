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

class DatePickerController: FormViewController {

  // MARK: - Private Properties

  private var date: Date? = nil
  private var selectedDate: Date!
  private var onAccept: ((Date?) -> Void)? = nil

  // MARK: - Class Methods

  class func present(
             for view: UIView,
    of viewController: UIViewController,
                 date: Date?,
             onAccept: ((Date?) -> Void)? = nil) {
    
    let datePickerController = StoryboardScene.Main.datePickerController.instantiate()
    datePickerController.modalPresentationStyle = .popover
    datePickerController.date = date
    datePickerController.onAccept = onAccept
    #warning("Calculate minimum size")
    datePickerController.preferredContentSize = CGSize(width: 300, height: 352)

    if let popoverPresentationController = datePickerController.popoverPresentationController {
      popoverPresentationController.permittedArrowDirections = .up
      popoverPresentationController.sourceView = view

      viewController.present(datePickerController, animated: true)
    }
  }


  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    
    form
      +++ Section(NSLocalizedString("Select Date", comment: "Form Section Title"))
      <<< DatePickerRow() { row in
        row.value = self.date
        row.onChange { (row) in
          self.selectedDate = row.value
        }
      }
  }


  // MARK: - Action Handlers

  @IBAction private func save(sender: Any) {
    onAccept?(selectedDate)
    dismiss(animated: true)
  }

  @IBAction private func cancel(sender: Any) {
    dismiss(animated: true)
  }
}
