//
//  ImageDownloader.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 11/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//
import Foundation
import CoreData
import UIKit
class ImageDownloader: ImageDownloadProtocol{
     private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     let apiClient = DogAPIClient.sharedInstance
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func getImage(withBreed breedName: String,completion: ((NSData) -> ())?){
        let requestSubbreeds = Breeds.fetchRequest() as NSFetchRequest<Breeds>
        let breeds = (try? self.context.fetch(requestSubbreeds))!
        var data = Data()
        self.apiClient.getRandomImage(withBreed: breedName, completion: { (result) in
            switch result{
            case .success(let img):
                for breed in breeds{
                    if breed.name == breedName{
                        let image = img.imageURL
                        do{
                            data = try Data(contentsOf: URL(string: image)!)
                        }
                        catch{
                            print ("error")
                        }
                        if breed.image == nil{
                            breed.image = data as NSData
                        }
                        
                        DispatchQueue.main.async {
                            self.appDelegate.saveContext()
                            completion?(data as NSData)
                        }
                    }
                }
            case .failure(let error):
                print (error)
            }
        })
        
    }
    func getImage(withBreed breedName: String, withSubreed subreedName: String,completion: ((NSData) -> ())?)
    {
        let requestSubbreeds = Subbreeds.fetchRequest() as NSFetchRequest<Subbreeds>
        let subbreeds = try? self.context.fetch(requestSubbreeds)
        var data = Data()
        self.apiClient.getRandomImage(withBreed:breedName,withSubbreed:subreedName,
                                      completion: { (result) in
                                        switch result{
                                        case .success(let img):
                                            for subreed in subbreeds!{
                                                if subreed.name == subreedName
                                                {
                                                    let image = img.imageURL
                                                    do{
                                                        data = try Data(contentsOf: URL(string: image)!)
                                                    }catch let error {
                                                        print("error: \(error)")
                                                    }
                                                    if subreed.image ==  nil {
                                                        subreed.image = data as NSData
                                                    }
                                                    DispatchQueue.main.async {
                                                        self.appDelegate.saveContext()
                                                        completion?(data as NSData)
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            print(error)
                                        }
        })
        
    }
    
}
