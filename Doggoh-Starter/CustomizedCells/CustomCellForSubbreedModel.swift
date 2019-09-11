//
//  CustomCellForSubbreedModel.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

struct CustomCellForSubbreedModel{
   let imageDog : NSData
   let nameDog : String?
    
    init(withDog dog: SubbreedModel, withImage image: Data) {
        imageDog = image as NSData
        nameDog = dog.name
    }
}
