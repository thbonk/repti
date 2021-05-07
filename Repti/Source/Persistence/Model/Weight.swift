//
//  Weight.swift
//  Repti
//
//  Created by Thomas Bonk on 05.01.21.
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
import CoreData

protocol WeightProtocol {
  var date: Date { get set }
  var weight: Float { get set }
}

extension Weight: WeightProtocol {

  // MARK: - Public Properties

  public var dao: WeightDAO {
    return WeightDAO(date: self.date, weight: self.weight)
  }

  // MARK: - Class Methods

  class func create(in managedObjectContext: NSManagedObjectContext) -> Weight {
    return
      NSEntityDescription
      .insertNewObject(
        forEntityName: Weight.entityName,
        into: managedObjectContext) as! Weight
  }
}

struct WeightDAO: WeightProtocol {

  // MARK: - Public Properties

  var date: Date
  var weight: Float


  // MARK: - Initialization

  init(date: Date, weight: Float) {
    self.date = date
    self.weight = weight
  }

  init(weighing: Weight) {
    self.date = weighing.date
    self.weight = weighing.weight
  }
}
