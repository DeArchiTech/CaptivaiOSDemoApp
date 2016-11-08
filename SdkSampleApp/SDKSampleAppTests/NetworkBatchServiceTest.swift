//
//  NetworkBatchService.swift
//  SDKSampleApp
//
//  Created by davix on 11/7/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
import Foundation
@testable import SDKSampleApp

class NetworkBatchServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateJsonPayload(){
        
        let service = NetworkBatchService.init(cookie: "")
        let payload = service.createJsonPayload()
        XCTAssertEqual(payload["captureFlow"], "RevaApp")
        XCTAssertEqual(payload["batchName"], "Batch_{NextId}")
        XCTAssertEqual(payload["batchRootLevel"], "1")

    }
    
    func testParseID() {
        
        let expected = "expectedID"
        let input : NSDictionary = ["content" : [ "id" : expected]]
        let batchService = NetworkBatchService.init(cookie : "")
        let result = batchService.parseID(dictionary: input)
        XCTAssertNotNil(result)
        XCTAssertEqual(expected, result)
        
    }
    
    func testCreateAndGetBatch() {

        let exp = expectation(description: "read")
        let sessionHelper = SessionHelper()
        sessionHelper.getCookieExpress(){
            cookie in
            var batchService = NetworkBatchService.init(cookie: cookie!)
            //Create a batch fullfil expectation in call back
            batchService.createBatch(){
                dict, errror in
                
                //Test Get Batch
                XCTAssertNotNil(dict)
                let batchID : String = batchService.parseID(dictionary: dict!)
                XCTAssertNotNil(batchID)
                batchService.getBatch(batchId: batchID){
                dict2, error2 in
                
                    //Expect expectations to be fulfilled
                    exp.fulfill()
                    XCTAssertNotNil(dict2)
              }
            }
        }
        waitForExpectations(timeout: 60, handler: {error in
        })
    }
    
}
