// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable superfluous_disable_command implicit_return
// swiftlint:disable sorted_imports
import CoreData
import Foundation

// swiftlint:disable attributes file_length vertical_whitespace_closing_braces
// swiftlint:disable identifier_name line_length type_body_length

// MARK: - BaseEntity

internal class BaseEntity: NSManagedObject {
  internal class var entityName: String {
    return "BaseEntity"
  }

  internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc internal class func fetchRequest() -> NSFetchRequest<BaseEntity> {
    return NSFetchRequest<BaseEntity>(entityName: entityName)
  }

  @nonobjc internal class func makeFetchRequest() -> NSFetchRequest<BaseEntity> {
    return NSFetchRequest<BaseEntity>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged internal var createdAt: Date
  @NSManaged internal var id: UUID
  internal var updatedAt: Date? {
    get {
      let key = "updatedAt"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Date
    }
    set {
      let key = "updatedAt"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: - Individual

internal class Individual: BaseEntity {
  override internal class var entityName: String {
    return "Individual"
  }

  override internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc internal class func fetchRequest() -> NSFetchRequest<Individual> {
    return NSFetchRequest<Individual>(entityName: entityName)
  }

  @nonobjc internal class func makeFetchRequest() -> NSFetchRequest<Individual> {
    return NSFetchRequest<Individual>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  internal var dateOfSale: Date? {
    get {
      let key = "dateOfSale"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Date
    }
    set {
      let key = "dateOfSale"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  @NSManaged internal var genderVal: Int16
  internal var hatchingDate: Date? {
    get {
      let key = "hatchingDate"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Date
    }
    set {
      let key = "hatchingDate"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  @NSManaged internal var name: String
  internal var ovipositionDate: Date? {
    get {
      let key = "ovipositionDate"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Date
    }
    set {
      let key = "ovipositionDate"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  internal var purchasingDate: Date? {
    get {
      let key = "purchasingDate"
      willAccessValue(forKey: key)
      defer { didAccessValue(forKey: key) }

      return primitiveValue(forKey: key) as? Date
    }
    set {
      let key = "purchasingDate"
      willChangeValue(forKey: key)
      defer { didChangeValue(forKey: key) }

      setPrimitiveValue(newValue, forKey: key)
    }
  }
  @NSManaged internal var pictures: Set<Picture>?
  @NSManaged internal var species: Species
  @NSManaged internal var weighings: Set<Weight>?
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: Relationship Pictures

extension Individual {
  @objc(addPicturesObject:)
  @NSManaged public func addToPictures(_ value: Picture)

  @objc(removePicturesObject:)
  @NSManaged public func removeFromPictures(_ value: Picture)

  @objc(addPictures:)
  @NSManaged public func addToPictures(_ values: Set<Picture>)

  @objc(removePictures:)
  @NSManaged public func removeFromPictures(_ values: Set<Picture>)
}

// MARK: Relationship Weighings

extension Individual {
  @objc(addWeighingsObject:)
  @NSManaged public func addToWeighings(_ value: Weight)

  @objc(removeWeighingsObject:)
  @NSManaged public func removeFromWeighings(_ value: Weight)

  @objc(addWeighings:)
  @NSManaged public func addToWeighings(_ values: Set<Weight>)

  @objc(removeWeighings:)
  @NSManaged public func removeFromWeighings(_ values: Set<Weight>)
}

// MARK: - Picture

internal class Picture: BaseEntity {
  override internal class var entityName: String {
    return "Picture"
  }

  override internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc internal class func fetchRequest() -> NSFetchRequest<Picture> {
    return NSFetchRequest<Picture>(entityName: entityName)
  }

  @nonobjc internal class func makeFetchRequest() -> NSFetchRequest<Picture> {
    return NSFetchRequest<Picture>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged internal var data: Data
  @NSManaged internal var filename: String
  @NSManaged internal var individual: Individual
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: - Species

internal class Species: BaseEntity {
  override internal class var entityName: String {
    return "Species"
  }

  override internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc internal class func fetchRequest() -> NSFetchRequest<Species> {
    return NSFetchRequest<Species>(entityName: entityName)
  }

  @nonobjc internal class func makeFetchRequest() -> NSFetchRequest<Species> {
    return NSFetchRequest<Species>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged internal var name: String
  @NSManaged internal var scientificName: String
  @NSManaged internal var individuals: Set<Individual>?
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: Relationship Individuals

extension Species {
  @objc(addIndividualsObject:)
  @NSManaged public func addToIndividuals(_ value: Individual)

  @objc(removeIndividualsObject:)
  @NSManaged public func removeFromIndividuals(_ value: Individual)

  @objc(addIndividuals:)
  @NSManaged public func addToIndividuals(_ values: Set<Individual>)

  @objc(removeIndividuals:)
  @NSManaged public func removeFromIndividuals(_ values: Set<Individual>)
}

// MARK: - Weight

internal class Weight: BaseEntity {
  override internal class var entityName: String {
    return "Weight"
  }

  override internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
  }

  @available(*, deprecated, renamed: "makeFetchRequest", message: "To avoid collisions with the less concrete method in `NSManagedObject`, please use `makeFetchRequest()` instead.")
  @nonobjc internal class func fetchRequest() -> NSFetchRequest<Weight> {
    return NSFetchRequest<Weight>(entityName: entityName)
  }

  @nonobjc internal class func makeFetchRequest() -> NSFetchRequest<Weight> {
    return NSFetchRequest<Weight>(entityName: entityName)
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged internal var date: Date
  @NSManaged internal var weight: Float
  @NSManaged internal var individual: Individual
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// swiftlint:enable identifier_name line_length type_body_length
