//
//  DogAPIClient2.swift
//  Doggoh-Starter
//
//  Created by Elena Gaman on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import Alamofire

enum DogAPI2{
    case tags
    case postTags

}
extension DogAPI2{
    var url: String {
        switch self {
        case .tags:
            return "tags"
        case .postTags:
            return "tags"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .tags:
            return .get
        case .postTags:
            return .post
        }
    }
}
class DogAPI2Client {
    static let sharedInstance = DogAPI2Client(baseURL:"https://api.imagga.com/v2/")
    
    let baseURL: String
    
    let headers: HTTPHeaders = ["Authorization": AuthParameter.basicAuth
    ]
    
    private init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private struct AuthParameter {
        static let basicAuth = "Basic YWNjXzZlOGM4ZjJjNGMzN2VjNjo3ZDUxODhjNTA0ZTYzYTVlMmIyNjFlMjgzNmI1MjRlOA=="
    }
    
    private struct Parameter {
        static let imageUrl = "image_url"
        static let image = "image"
    }
    
    func getTags(for imageURL: String) {
        let parameters = [Parameter.imageUrl : imageURL]
        request(endpoint: DogAPI2.tags, parameters: parameters).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                if let data = response.data {
                    do {
                        print(value)
                        let responseObject = try JSONDecoder().decode(TagsResponse.self, from: data)
                        print(responseObject)
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
        }
    }

    func postTags(with image: UIImage,_ completion: @escaping (Result<[String], Error>) -> Void){
        let url = "\(baseURL)\(DogAPI2.postTags.url)"
        AF.upload(multipartFormData: { (multipartFromData) in
            multipartFromData.append(image.pngData()!, withName: Parameter.image, fileName: "dog.jpg", mimeType: "image/jpg")
        }, to: url, headers: headers).responseJSON { response in
            switch response.result {
            case .failure(let error):
               completion(.failure(error))
            case .success(let value):
                if let data = response.data {
                    do {
                      //  print(value)
                        var dogs : [String] = []
                        
                        let responseObject = try JSONDecoder().decode(TagsResponse.self, from: data)
                     //   print(responseObject)
                        for item in responseObject.result.tags{
                            dogs.append(item.tag.en)
                        }
                        completion(.success(dogs))
                    }
                    catch let error {
                        print(error)
                         completion(.failure(error))
                    }
                }
            }
        }
    }
    private func request(endpoint: DogAPI2,
                         parameters: Parameters? = nil
        ) -> DataRequest {
        let url = "\(baseURL)\(endpoint.url)"
        return AF.request(url, method: endpoint.method, parameters: parameters, headers: headers)
    }
    
}


