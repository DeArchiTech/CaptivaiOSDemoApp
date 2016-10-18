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
    
    func testGetProfileWithProfileName(){
        
        //1)Set up a service
        let service = CreateProfileService()
        
        //2)Mock up a CreateProfile Object
        let nameOne = "profileOne"
        let nameTwo = "profileTwo"
        let profileOne = FilterProfile()
        profileOne.profileName = nameOne
        let profileTwo = FilterProfile()
        profileTwo.profileName = nameTwo
        
        //3)Attempt to save object in DB
        let saveResultOne = service.saveProfile(profile: profileOne)
        let saveResultTwo = service.saveProfile(profile: profileTwo)
        XCTAssertTrue(saveResultOne)
        XCTAssertTrue(saveResultTwo)
        
        let result = service.getProfileWithProfileName(name: nameTwo)
        XCTAssertNotNil(result)
    }
    
    func testUpdateProfileSelectedToTrue(){
        
        //It updates selected to true for the desired profile name
        let service = CreateProfileService()
        let name = "profileMate"
        let profile = FilterProfile()
        profile.profileName = name
        profile.selected = false
        
        let saveResultOne = service.saveProfile(profile: profile)
        XCTAssertTrue(saveResultOne)
        
        let updateResult = service.updateProfileSelectedToTrue(name: name)
        XCTAssertTrue(updateResult)
        
        let result = service.getProfileWithProfileName(name: name)
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.selected)
    }
    
}
