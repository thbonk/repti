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
import CoreData

enum Gender: Int16 {
  case male = 0
  case female = 1
  case unknown = 255
}

extension Individual {

  // MARK: - Public Properties

  var gender: Gender {
    set {
      genderVal = newValue.rawValue
    }
    get {
      return Gender(rawValue: genderVal)!
    }
  }

  
  // MARK: - Class Methods

  class func create(in managedObjectContext: NSManagedObjectContext) -> Individual {
    return
      NSEntityDescription
      .insertNewObject(
        forEntityName: Individual.entityName,
        into: managedObjectContext) as! Individual
  }
}
