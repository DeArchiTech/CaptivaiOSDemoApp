//
//  CreateProfileServiceTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/17/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import XCTest
import RealmSwift
@testable import SDKSampleApp

class CreateProfileServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddFilterToList() {

        //"creates a filter profile with the list of filters selected"
        let vc = CreateProfileViewController()
        let filterOne = "One filter"
        let filterTwo = "Second filter"
        vc.addFilterToList(filter: filterOne)
        vc.addFilterToList(filter: filterTwo)
        let result = vc.createFilterProfile()
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.filters.count)
        XCTAssertEqual(result?.filters.count, 2)
    
    }
    
    func testUpdateAllSelectedToFalse(){
        
        // it Updates all the selected columns to false
        let service = CreateProfileService()
        let result = service.updateAllSelectedToFalse()
        XCTAssertTrue(result)
    }
    
}
