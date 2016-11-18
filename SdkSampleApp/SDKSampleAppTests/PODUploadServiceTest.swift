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
    
    func testUploadPodNumberWithTimeout(){
     
        let exp = expectation(description: "read")
        let sessionHelper = SessionHelper()
        sessionHelper.getCookieExpress(){
            cookie in
            
            let podUploadService = PODUploadService.init(cookie: cookie!)
            podUploadService.uploadPODNumber(timeout: 1, pod: "ABCD"){
                dict, error in
                XCTAssertNil(dict)
                XCTAssertNotNil(error)
                exp.fulfill()
            }
            
        }
        waitForExpectations(timeout: 60, handler: {error in
        })
        
    }
    
}
