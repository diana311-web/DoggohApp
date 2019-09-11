//
//  Dog+CoreDataProperties.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?

}
