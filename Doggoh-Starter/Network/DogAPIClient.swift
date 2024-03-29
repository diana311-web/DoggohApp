//
//  DogAPIClient.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum DogAPI {
    case allDogs
    case randomImage
    case randomImgaeNumber(nr: Int)
    case image(breed: String)
    case imageSubbreed(breed: String, subbreed: String)
}

extension DogAPI {
    var endpoint: String {
        switch self {
        case .allDogs:
            return "breeds/list/all"
        case .randomImage:
            return "breeds/image/random"
        case .image(let breed):
            return "breed/\(breed)/images/random"
        case .imageSubbreed(let breed, let subbreed):
            return "breed/\(breed)/\(subbreed)/images/random"
        case .randomImgaeNumber (let nr) :
            return "breeds/image/random/\(nr)"
        }
    }
    
}

class DogAPIClient {
    let baseURL: URL
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let sharedInstance = DogAPIClient(baseURL: URL(string: "https://dog.ceo/api/")!)
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    func createDataBreed(image: String, breed: String ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "BreedDB", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        user.setValue(breed, forKey: "name")
        
        user.setValue(image, forKey: "image")
        
        print(user, "meeeeee")
        
        do {
            
            try managedContext.save()
            
        } catch let error as NSError {
            
            print(error)
            
        }
        
    }
    func getAllDogs(_ completion: @escaping (Result<[Doggye], NetworkError>) -> Void) {
        let url = URL(string: "\(baseURL)\(DogAPI.allDogs.endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    var dogs: [Doggye] = []
                    let allDogs = try JSONDecoder().decode(AllDogsResponse.self, from: data)
                    allDogs.message.forEach({
                    let request = Breeds.fetchRequest() as NSFetchRequest<Breeds>
                    request.predicate = NSPredicate(format: "name =%@", $0.key)
                        do{
                            let result = try self.context.fetch(request).first
                            if result == nil{
                                    let dogBreed = Breeds(entity: Breeds.entity(), insertInto: self.context)
                                   dogBreed.name = $0.key
                                    for item in $0.value{
                                        let dogSubbreed = Subbreeds(entity: Subbreeds.entity(), insertInto: self.context)
                                        dogSubbreed.name = item
                                        dogBreed.addToHas(dogSubbreed)
                                      
                                    }
                            }
                                        }
                        catch{

                            print("Failed")
                        }
                        dogs.append(Doggye(breed: $0.key, subBreeds: $0.value))
                    })
                    self.appDelegate.saveContext()
                    completion(.success(dogs))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getRandomImage(_ completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.randomImage.endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImage.self, from: data)
                    completion(.success(image))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    func getRandomImage(withNoImages nr : Int,_ completion: @escaping (Result<[UIImage], NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.randomImgaeNumber(nr: nr).endpoint)")!
        print ("url",url)
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do{
                    let reply = try JSONDecoder().decode(DogImagesReply.self, from: data)
                    var images = [UIImage]()
                    for item in reply.message{
                        let url = URL(string: item)!
                        let data = try Data(contentsOf: url)
                        images.append(UIImage(data: data)!)
                    }
                    completion(.success(images))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getRandomImage(withBreed breed: CustomCellForBreedModel, completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.image(breed: breed.breedName).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
    
                do {
                    let image = try JSONDecoder().decode(DogImage.self, from: data)
                    completion(.success(image))
                    
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    func getRandomImage(withBreed breed: String, completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.image(breed: breed).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImage.self, from: data)
                    DispatchQueue.main.async {
                         completion(.success(image))
                    }
                   
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getRandomImage(withBreed breed: BreedModel, withSubbreed subbreed : SubbreedModel
        , completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.imageSubbreed(breed: breed.breedName, subbreed: subbreed.name).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImage.self, from: data)
                    completion(.success(image))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    func getRandomImage(withBreed breed: String, withSubbreed subbreed : String
        , completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.imageSubbreed(breed: breed, subbreed: subbreed).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImage.self, from: data)
                    completion(.success(image))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
}
