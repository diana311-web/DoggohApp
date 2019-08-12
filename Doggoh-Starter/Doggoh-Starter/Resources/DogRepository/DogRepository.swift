//
//  DogRepository.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 06/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

struct DogRepository {
    static let statementsFilename = "dog_questions_multiple"
    
    static func dataFromJSON(withName name: String) -> Dictionary<String, AnyObject>? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("error finding json file at path: \(name).json")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{
                // json loaded, do stuff
                //print("json loaded: \(jsonResult)")
                return jsonResult
            }
        } catch let error{
            // handle error
            print("error loading json file: \(error)")
            return nil
        }
        
        return nil
    }

    }



