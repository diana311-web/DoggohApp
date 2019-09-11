//
//  Subbreeds+CoreDataProperties.swift
//  
//
//  Created by Elena Gaman on 30/08/2019.
//
//

import Foundation
import CoreData


extension Subbreeds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subbreeds> {
        return NSFetchRequest<Subbreeds>(entityName: "Subbreeds")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var owner: Breeds?

}
