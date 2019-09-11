//
//  DogsViewControllerModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Elena Gaman on 06/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest

@testable import Doggoh_Starter
class MockImageDonwloader : ImageDownloadProtocol{
    func getImage(withBreed breedName: String, completion: ((NSData) -> ())?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) {
            completion?(breedName.data(using: .utf8)! as NSData )
        }
    }
    
    func getImage(withBreed breedName: String, withSubreed subreedName: String,completion: ((NSData) -> ())?){
       completion?(subreedName.data(using: .utf8)! as NSData )
    }
    
    
}

class DogsViewControllerModelTest: XCTestCase {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expectedName : String!
    var expectedNumberOfBreeds : Int!
    var expectedCellForBreedName : CustomCellForBreedModel!
    var expectedCustomCellForSubreed : CustomCellForSubbreedModel!
    var firstExptectedSubreed : String!
    var list : [SubbreedModel] = []
    var sut : DogsViewCoontrllerModel!
    var expectedImage : NSData?
    var breed : [BreedModel]!
    override func setUp() {
        list.append(SubbreedModel(image: Data(), name: "frise"))
        breed = [BreedModel(breedName: "bichon", breedImage: Data(), subbreedList: list)]
        sut = DogsViewCoontrllerModel(withBreeds: breed)
        sut.imgDelegate = MockImageDonwloader()
        expectedName = breed[0].breedName
        expectedNumberOfBreeds = breed.count
        // let expectedNumberOfSubbreeds = breed[0].subbreedList.count
        expectedCellForBreedName = CustomCellForBreedModel(withBreed: breed[0])
        expectedCustomCellForSubreed = CustomCellForSubbreedModel(withDog: breed[0].subbreedList[0], withImage: Data())
        firstExptectedSubreed = breed[0].subbreedList[0].name
    
    }
    func testBreedName(){
          XCTAssertGreaterThanOrEqual(sut.breed(atIndex: 0).breedName , expectedName)
    }
    func testNumberOfBreeds(){
           XCTAssertEqual(sut.numberOfBreeds(), expectedNumberOfBreeds)
    }
    func testNumberOfSubreeds(){
         XCTAssertEqual(sut.numberOfSubreedsInBreeds(atIndex: 0), sut.numberOfSubreedsInBreeds(atIndex: 0))
    }
    func testExpectedCellForBreedName(){
         XCTAssertEqual(expectedCellForBreedName.breedName, sut.customCellForBreedModel(atIndex: 0).breedName)
    }
    func testFirstExptectedSubreed(){
          XCTAssertEqual(firstExptectedSubreed, sut.firstSubbreedInBreed(atIndex: 0))
    }
    func testExpectedCustomCellForSubreed(){
          XCTAssertEqual(expectedCustomCellForSubreed.nameDog, sut.customCellFirSubreedModel(withBreedIndex: 0, withSubreedIndex: 0, withImage: Data()).nameDog)
    }
    
    
    func testGetImageForBreed() {
        let expectedResult = breed[0].breedName.data(using: .utf8) as! NSData
        let expectResult = self.expectation(description: "set image")
        
        sut.imgDelegate!.getImage(withBreed: expectedName, completion: {
            result in
                XCTAssertEqual(expectedResult, result)
                expectResult.fulfill()
            })
        wait(for: [expectResult], timeout: 5)
    }
     func testGetImageForSubbreed() {
        let expectedResult = breed[0].subbreedList[0].name.data(using: .utf8) as! NSData
        sut.imgDelegate?.getImage(withBreed: expectedName, withSubreed: breed[0].subbreedList[0].name, completion: {
            result in
                XCTAssertEqual(expectedResult, result)
        })
    }
    
    
}
