//
//  DogAPIClient.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
enum DogAPI {
    case allDogs
    case randomImage
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
        }
    }
    
}

class DogAPIClient {
    let baseURL: URL
    
    static let sharedInstance = DogAPIClient(baseURL: URL(string: "https://dog.ceo/api/")!)
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
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
                        dogs.append(Doggye(breed: $0.key, subBreeds: $0.value))
                    })
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
                    completion(.success(image))
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }

    func getRandomImage(withBreed breed: String, withSubbreed subbreed : String, completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
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
