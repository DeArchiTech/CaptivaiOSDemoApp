//
//  MainViewControllerTest.swift
//  SDKSampleApp
//
//  Created by davix on 11/2/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift
@testable import SDKSampleApp

class MainViewControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetAndPersistCookie(){
    
        let vc = MainViewController()
        let readyExpectation = expectation(description: "read")
        
        vc.getAndPersistCookie {
            readyExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: { error in
            XCTAssertNil(error, "Error")
        })        
    }
}
