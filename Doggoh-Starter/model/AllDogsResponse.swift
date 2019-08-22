//
//  AllDogsResponse.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
typealias Breed = String
typealias Subbreed = String

struct AllDogsResponse: Codable {
    let message: [Breed: [Subbreed]]
}
