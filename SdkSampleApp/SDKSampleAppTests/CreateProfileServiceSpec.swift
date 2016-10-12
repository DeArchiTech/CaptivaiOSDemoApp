//
//  CreateProfileServiceSpec.swift
//  SDKSampleApp
//
//  Created by davix on 10/5/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
@testable import SDKSampleApp

class CreateProfileServiceSpec: QuickSpec {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    override func spec() {
        describe("Save Profile") {
            it("it saves the profile in the Realm database") {
                
                //1)Create a CreateProfile Service
                let service = CreateProfileService()
                    
                //2)Mock up a CreateProfile Object
                let profile = FilterProfile()
                profile.profileName = "testName"

                //3)Attempt to save object in DB
                let result = service.saveProfile(profile: profile)

                //4)Assert that the object is save and persists
                expect(result).to(beTruthy())
                
            }
            it("it saves a profile with a filter object") {
                
                //1)Create a CreateProfile Service
                let service = CreateProfileService()
                
                //2)Mock up a CreateProfile Object
                let profile = FilterProfile()
                profile.profileName = "testName"
                
                let filterObject = FilterObject()
                filterObject.filterName = "filterName"
                profile.filters.append(filterObject)
                
                //3)Attempt to save object in DB
                let result = service.saveProfile(profile: profile)
                
                //4)Assert that the object is save and persists
                expect(result).to(beTruthy())
                
            }
        }
        describe("Load Profile") {
            it("it loads a list of profile") {
                
                //1)Create a CreateProfile Service
                let service = CreateProfileService()
                
                //2)Mock up a list of profile objects
                let profileOne = FilterProfile()
                profileOne.profileName = "AAA"
                
                let profileTwo = FilterProfile()
                profileTwo.profileName = "BBB"
                
                let profileThree = FilterProfile()
                profileThree.profileName = "CCC"
                
                //3)Attempt to save object in DB
                let resultOne = service.saveProfile(profile: profileOne)
                let resultTwo = service.saveProfile(profile: profileTwo)
                let resultThree = service.saveProfile(profile: profileThree)
                
                //4)Ensures profiles are saved
                expect(resultOne).to(beTruthy())
                expect(resultTwo).to(beTruthy())
                expect(resultThree).to(beTruthy())
                
                //5)Attempt to load objects from database
                let finalResult = service.loadProfiles()
                expect(finalResult).notTo(equal(nil))
                expect(finalResult?.count).to(equal(3))
                
            }
        }
        describe("Delete Profile") {
            it("it deletes all profiles") {
                
                //1)Create a service
                let service = CreateProfileService()
                
                //2)Save a profile
                let profile = FilterProfile()
                profile.profileName = "tempProfile"
                let saveResult = service.saveProfile(profile: profile)
                expect(saveResult).to(beTruthy())

                //3)Attempt to load objects from database
                let firstLoadResult = service.loadProfiles()
                expect(firstLoadResult).notTo(equal(nil))
                expect(firstLoadResult?.count).to(equal(1))
                
                //4)Attempt to delete profiles
                let deleteResult = service.deleteAllProfiles()
                expect(deleteResult).notTo(equal(nil))
                expect(deleteResult).to(beTruthy())
                
                //5)Load objects from database and assert its zero
                let loadResult = service.loadProfiles()
                expect(loadResult).notTo(equal(nil))
                expect(loadResult?.count).to(equal(0))
                
            }
        }
        describe("Contains Profile Name"){
            it("it checks the database to see if such profile name exists"){
                
                //1)First check that profile name doesn't exist in the database
                let service = CreateProfileService()
                let profileName = "Some Profile Name"
                var containsResult = service.containsProfileName(name: profileName)
                expect(containsResult).to(beFalse())
                
                //2)Try to persist profile with name in the database
                let profile = FilterProfile()
                profile.profileName = profileName
                let saveResult = service.saveProfile(profile: profile)
                expect(saveResult).to(beTruthy())
                
                //3)Check again and profile name should be in the database
                containsResult = service.containsProfileName(name: profileName)
                expect(containsResult).to(beTruthy())
            }
        }
    }
}
