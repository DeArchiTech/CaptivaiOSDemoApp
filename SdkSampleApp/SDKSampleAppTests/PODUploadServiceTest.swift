//
//  PODUploadServiceTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/27/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import XCTest
@testable import SDKSampleApp

class PODUploadServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUploadPODNumber(){
        
        //1)Login To Get a Live Cookie
        let manager : LoginService = LoginService.init()
        let readyExpectation = expectation(description: "read")
        manager.login() { (dictionary,error) -> () in
            XCTAssertNotNil(dictionary)
            readyExpectation.fulfill()
        }
        
        //2)Call Upload Service to upload with POD number
        waitForExpectations(timeout: 60, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testGetEncodedTxtFileFromPod(){
        
        let pod = "1234"
        let service = PODUploadService()
        let result = service.getEncodedTxtFileFromPod(pod: pod)
        XCTAssertNotNil(result)
        
    }
    
}
