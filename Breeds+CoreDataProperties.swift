//
//  Breeds+CoreDataProperties.swift
//  
//
//  Created by Elena Gaman on 30/08/2019.
//
//

import Foundation
import CoreData


extension Breeds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breeds> {
        return NSFetchRequest<Breeds>(entityName: "Breeds")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var has: NSSet?

}

// MARK: Generated accessors for has
extension Breeds {

    @objc(addHasObject:)
    @NSManaged public func addToHas(_ value: Subbreeds)

    @objc(removeHasObject:)
    @NSManaged public func removeFromHas(_ value: Subbreeds)

    @objc(addHas:)
    @NSManaged public func addToHas(_ values: NSSet)

    @objc(removeHas:)
    @NSManaged public func removeFromHas(_ values: NSSet)

}
