//
//  CustomCellForBreedModel.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

struct CustomCellForBreedModel{
    let breedImage : NSData
    let breedName : String
    
    init(withBreed breed: BreedModel) {
    breedImage = breed.breedImage as NSData
    breedName = breed.breedName   
    }
}
