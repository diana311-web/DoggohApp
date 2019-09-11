//
//  Breeds+CoreDataProperties.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//
//

import Foundation
import CoreData


extension Breeds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breeds> {
        return NSFetchRequest<Breeds>(entityName: "Breeds")
    }

    @NSManaged public var image: NSData?
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
