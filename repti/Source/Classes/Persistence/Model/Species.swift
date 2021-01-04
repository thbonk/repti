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
import Combine
import CoreData

protocol SpeciesProtocol {
  var name: String { get set }
  var scientificName: String { get set }
  var individuals: Set<Individual>? { get set }
}

extension Species: SpeciesProtocol {

  // MARK: - Class Methods

  class func create(in managedObjectContext: NSManagedObjectContext) -> Species {
    return
      NSEntityDescription
        .insertNewObject(
          forEntityName: Species.entityName,
                   into: managedObjectContext) as! Species
  }
}

struct  SpeciesDAO: SpeciesProtocol {

  // MARK: - Public Properties

  var name: String = ""
  var scientificName: String = ""
  var individuals: Set<Individual>? = Set()


  // MARK: - Initialization

  init(species: Species? = nil) {
    if let species = species {
      name = species.name
      scientificName = species.scientificName
      individuals = species.individuals
    }
  }
}
