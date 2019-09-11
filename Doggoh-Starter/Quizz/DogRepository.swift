//
//  DogRepository.swift
//  Quizlee
//
//  Created by Razvan Apostol on 01/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct DogRepository {

    static let statementsFilename = "dog_statements"
    static let dogBreedsFilename = "alldogsresponse"
    static let statements2Filename = "dog_questions_multiple"

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
//                print("json loaded: \(jsonResult)")
                return jsonResult
            }
        } catch let error{
            // handle error
            print("error loading json file: \(error)")
            return nil
        }

        return nil
    }
    static func getAllDogsDict() -> Dictionary<String, [String]> {
        var allDogBreedsDict: Dictionary<String, [String]> = [:]
        if let json = DogRepository.dataFromJSON(withName: DogRepository.dogBreedsFilename) {
            //            print(json)
            allDogBreedsDict = json["message"] as! Dictionary<String, [String]>
        }
        return allDogBreedsDict
    }
}
