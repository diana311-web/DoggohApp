//
//  DogsViewCoontrllerModel.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 03/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import CoreData
import UIKit
protocol ImageDownloadProtocol{
    func getImage(withBreed breedName: String,completion: ((NSData) -> ())?)
    func getImage(withBreed breedName: String, withSubreed subreedName: String,completion: ((NSData) -> ())?)
}
class DogsViewCoontrllerModel{
     var breedList = [BreedModel]()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let dogsBreed : [BreedModel]!
    let apiClient = DogAPIClient.sharedInstance
    var imgDelegate : ImageDownloadProtocol?
    init(withBreeds breeds :[BreedModel]){
        self.dogsBreed = breeds
        imgDelegate = ImageDownloader()
    }
    func numberOfBreeds()->Int{
        return dogsBreed.count
    }
    func numberOfSubreedsInBreeds(atIndex index:Int) -> Int{
        return dogsBreed[index].subbreedList.count
    }
    func customCellForBreedModel(atIndex index: Int) -> CustomCellForBreedModel{
        return CustomCellForBreedModel(withBreed: dogsBreed[index])
    }
    func customCellFirSubreedModel(withBreedIndex breedIndex:Int, withSubreedIndex subreedIndex: Int, withImage image: Data) -> CustomCellForSubbreedModel{
        return CustomCellForSubbreedModel(withDog: dogsBreed[breedIndex].subbreedList[subreedIndex], withImage: image)
    }
    func breed(atIndex index: Int) -> BreedModel{
        return dogsBreed[index]
    }
    func firstSubbreedInBreed(atIndex index: Int) -> String {
        return dogsBreed[index].subbreedList.first?.name ?? "nothing"
    }

}
