//
//  DogCollectionViewCellClassModel.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 06/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

struct DogCollectionViewCellClassModel {
    
    let image : UIImage
    let dogName : String
    
    init(withDog dog: DogDataModel){
        image = dog.image
        dogName = dog.name
    }
}
