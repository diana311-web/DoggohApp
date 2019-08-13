//
//  Dog.swift
//  TestProject
//
//  Created by George Galai on 01/08/2019.
//  Copyright © 2019 George Galai. All rights reserved.
//

import UIKit

struct Dog
{
    var image: UIImage
    var name: String

    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }

    init?(dictionary: [String: String]) {
        guard let name = dictionary["Name"], let photo = dictionary["Photo"],
            let image = UIImage(named: photo) else {
                return nil
        }

        self.init(image: image, name: name)
    }

    static func allDogs() -> [Dog] {
        var dogs = [Dog]()
        guard let URL = Bundle.main.url(forResource: "Dogs", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                print (dogs)
                return dogs
        }
        for dictionary in photosFromPlist {
            if let dog = Dog(dictionary: dictionary) {
                dogs.append(dog)
            }
        }
        return dogs
    }
}

extension Dog: Equatable {
    static func ==(lhs: Dog, rhs:Dog) -> Bool {
        return lhs.name == rhs.name && lhs.image == rhs.image
    }
}
