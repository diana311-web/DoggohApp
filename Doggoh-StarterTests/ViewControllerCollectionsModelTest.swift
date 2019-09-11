//
//  ViewControllerCollectionsModel.swift
//  Doggoh-StarterTests
//
//  Created by Elena Gaman on 07/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class ViewControllerCollectionsModelTest: XCTestCase {
    var sut : ViewControllerCollectionsModel!
    var exepectedGogs: [DogDataModel]!
    override func setUp() {
           let dogsExpectation = expectation(description: "Expecting to get a valid dog")
        let dogs = DogDataModel.allDogs()
        
    }
    

}
