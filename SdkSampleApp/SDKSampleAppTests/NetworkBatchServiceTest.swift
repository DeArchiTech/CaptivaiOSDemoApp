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
            let batchService = NetworkBatchService.init(cookie: cookie!)
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
    
    func testCreateUpdatePayload() {
        
        let service = NetworkBatchService.init(cookie: "")

        let values : [String:String] = ["aaa":"aaa" , "bbb":"bbb", "ccc":"ccc"]
        let expectedNodesArray = service.createNodesArray(value: values)
        
        //Test Dispatch
        let payload = service.createUpdatePayload(value: values)
        XCTAssertEqual(payload["dispatch"]! as! String, "S")
        
        //Test Nodes
        let acturalNodeArrayResult = payload["nodes"]! as! [[String:Any]]
        let expectedCount = expectedNodesArray.count
        let resultCount = acturalNodeArrayResult.count
        XCTAssertEqual(resultCount, expectedCount)
        
        //Test Values
        let acturalValuesArrayResult = payload["values"]! as! [[String:Any]]
        let expValuesArray = service.createValuesArray(value: values)
        let acturalValuesCount = acturalValuesArrayResult.count
        let expectedValuesCount = expValuesArray.count
        XCTAssertEqual(acturalValuesCount, expectedValuesCount)
    }
    
    func testCreateAndUpdateBatch() {
        
        let exp = expectation(description: "read")
        let sessionHelper = SessionHelper()
        sessionHelper.getCookieExpress(){
            cookie in
            let batchService = NetworkBatchService.init(cookie: cookie!)
            //Create a batch fullfil expectation in call back
            batchService.createBatch(){
                dict, errror in
                
                //Test Update Batch
                XCTAssertNotNil(dict)
                let batchID : String = batchService.parseID(dictionary: dict!)
                XCTAssertNotNil(batchID)
                let values : [String:String] = [:]
                batchService.updateBatch(batchId: batchID, value: values){
                    dict2, error2 in
                    
                    //Expect expectations to be fulfilled
                    exp.fulfill()
                    let result = dict2! as NSDictionary
                    XCTAssertNotNil(result)
                }
            }
        }
        waitForExpectations(timeout: 60, handler: {error in
        })
    }
    
    func testCreateNodesDictionary(){
        
        let nodeId : String = "Expected"
        let expected = ["nodeId":nodeId ,"parentId":0] as NSDictionary
        let service = NetworkBatchService.init(cookie: "")
        let result = service.createNodesDictionary(nodeId: nodeId)
        XCTAssertEqual(expected, result)
        
    }
    
    func testCreateValuesDictionary(){
        
        let nodeId = "nodeId"
        let valueName = "OutputImage"
        let value = "value"
        var expected : [String:String] = ["nodeId":nodeId,"valueName":valueName,"value":value,"valueType":"file","offset":"0","fileExtension":"jpg"]
        let service = NetworkBatchService.init(cookie: "")
        let result : [String:String] = service.createValuesDictionary(nodeId: nodeId, fileExtension: valueName, value: value)
        XCTAssertEqual(expected["nodeId"], result["nodeId"])
        XCTAssertEqual(expected["valueName"], result["valueName"])
        XCTAssertEqual(expected["value"], result["value"])
    
    }
    
    func testCreateNodesArray(){
        
        let service = NetworkBatchService.init(cookie: "")
        let result : [[String: Any]] = service.createNodesArray(value: [:])
        XCTAssertEqual(0 , result.count)
        
    }
    
}
