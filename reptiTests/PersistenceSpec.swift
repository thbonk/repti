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
import Quick
import Nimble

@testable import repti

class PersistenceSpec: QuickSpec {
  override func spec() {

    describe("Instantiating CoreDataStore") {
      it("Instantiation is succesfull") {
        let _ = CoreDataStore(inMemory: true)
      }
    }

    describe("Species tests") {
      let store = CoreDataStore(inMemory: true)

      it("Create species and save it") {
        let species = Species.create(in: store.persistentContainer.viewContext)

        species.name = "Name"
        species.scientificName = "Scientific Name"

        try store.saveContext()
      }

      it("Query species") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(species).toNot(beEmpty())
        expect(species[0].createdAt).to(equal(species[0].updatedAt))
      }

      it("Query species and update it") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        species[0].name = "Updated name"

        try store.saveContext()
      }

      it("Query species and check whether it was updated successfuly") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(species).toNot(beEmpty())
        expect(species[0].createdAt).to(beLessThan(species[0].updatedAt))
        expect(species[0].name).to(equal("Updated name"))
      }

      it("Query species and delete it") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(species).toNot(beEmpty())

        store.persistentContainer.viewContext.delete(species[0])

        try store.saveContext()
      }

      it("Query species and check that there is none available") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(species).to(beEmpty())
      }
    }

    describe("Species with individuals") {
      var store = CoreDataStore(inMemory: true)

      it("Create species with individual") {
        let species = Species.create(in: store.persistentContainer.viewContext)
        species.name = "Name"
        species.scientificName = "Scientific Name"

        let individual = Individual.create(in: store.persistentContainer.viewContext)

        individual.name = "Individual Name"
        individual.gender = .female
        individual.species = species

        species.addToIndividuals(individual)

        try store.saveContext()
      }

      it("Query species with individuals") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        fetchRequest.includesSubentities = true
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(species).toNot(beEmpty())
        expect(species[0].individuals).toNot(beEmpty())
        expect(species[0].individuals!.first!.name).to(equal("Individual Name"))
        expect(species[0].individuals!.first!.gender).to(equal(.female))
      }

      it("Query individual and delete it") {
        let fetchRequest: NSFetchRequest<Individual> = Individual.makeFetchRequest()
        let individuals = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(individuals).toNot(beEmpty())

        store.persistentContainer.viewContext.delete(individuals[0])
        try store.saveContext()
      }

      it("Query species and check that it has no individuals") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        fetchRequest.includesSubentities = true
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(species).toNot(beEmpty())
        expect(species[0].individuals).to(beEmpty())
      }

      it("Create new store") {
        store = CoreDataStore(inMemory: true)
      }

      it("Create species with individual") {
        let species = Species.create(in: store.persistentContainer.viewContext)
        species.name = "Name"
        species.scientificName = "Scientific Name"

        let individual = Individual.create(in: store.persistentContainer.viewContext)

        individual.name = "Individual Name"
        individual.gender = .female
        individual.species = species

        species.addToIndividuals(individual)

        try store.saveContext()
      }

      it("Query species and delete it") {
        let fetchRequest: NSFetchRequest<Species> = Species.makeFetchRequest()
        fetchRequest.includesSubentities = true
        let species = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(species).toNot(beEmpty())

        store.persistentContainer.viewContext.delete(species[0])

        try store.saveContext()
      }

      it("Query individual and make sure that none was found") {
        let fetchRequest: NSFetchRequest<Individual> = Individual.makeFetchRequest()
        let individuals = try! store.persistentContainer.viewContext.fetch(fetchRequest)

        expect(individuals).to(beEmpty())
      }
    }
  }
}
