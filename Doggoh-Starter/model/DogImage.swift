//
//  DpgImage.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
struct DogImage: Codable {
    let status: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "message"
        case status = "status"
    }
}
