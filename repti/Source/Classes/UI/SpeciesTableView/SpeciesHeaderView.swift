//
//  SpeciesHeaderView.swift
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

class SpeciesHeaderView: UIView {

  // MARK: Public Properties

  public var isExpanded = false
  var species: Species! {
    didSet {
      nameLabel.text = species.name
      scientificNameLabel.text = species.scientificName
    }
  }
  

  // MARK: - Private Properties

  @IBOutlet
  private var nameLabel: UILabel!
  @IBOutlet
  private var scientificNameLabel: UILabel!
  @IBOutlet
  private var deleteButton: UIButton!
  private var deleteHandler: ((Species) -> ())?
  @IBOutlet
  private var editButton: UIButton!
  private var editHandler: ((Species) -> ())?
  @IBOutlet
  private var addIndividualButton: UIButton!
  private var addHandler: ((Species) -> ())?


  // MARK: - Class Methods

  class func loadView(
    for species: Species,
    deleteHandler: ((Species) -> ())? = nil,
    editHandler: ((Species) -> ())? = nil,
    addHandler: ((Species) -> ())? = nil) -> SpeciesHeaderView {

    let bundle = Bundle(for: SpeciesHeaderView.self)
    let nibName = String(describing: SpeciesHeaderView.self)
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiate(withOwner: nil, options: nil).first as! SpeciesHeaderView

    view.species = species

    view.deleteHandler = deleteHandler
    view.editHandler = editHandler
    view.addHandler = addHandler

    return view
  }


  // MARK: - Action Handlers

  @IBAction
  private func callDeleteHandler() {
    deleteHandler?(species)
  }

  @IBAction
  private func callEditHandler() {
    editHandler?(species)
  }

  @IBAction
  private func callAddHandler() {
    addHandler?(species)
  }
}
