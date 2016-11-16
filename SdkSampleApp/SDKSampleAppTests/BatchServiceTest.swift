//
//  BatchServiceTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/25/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift
@testable import SDKSampleApp

class BatchServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    
    }
    
    func testUpdate(){
//        let service = BatchService()
//        service.deleteAllBatches()
//        
//        let batchNumber = 123
//        let batch = BatchObj()
//        batch.batchNumber = batchNumber
//        service.saveBatch(batch: batch)
//        
//        let firstLoadResult = service.getBatchWithBatchNum(num: batchNumber)
//        XCTAssertFalse((firstLoadResult?.uploaded)!)
//        let updateResult = service.updateBatchUpdatedToTrue(num: batchNumber)
//        XCTAssertTrue(updateResult)
//        let secondLoadResult = service.getBatchWithBatchNum(num: batchNumber)
//        XCTAssertEqual(secondLoadResult?.uploaded, true)

    }
    
    func testCreateBatchWithHightestPrimaryKey(){
        
        let service = BatchService()
        let batch = BatchObj()
        let batchNum = 10
        batch.batchNumber = batchNum
        XCTAssertTrue(service.deleteAllBatches())
        XCTAssertTrue(service.saveBatch(batch: batch))
        let result = service.createBatchWithHightestPrimaryKey()
        XCTAssert(result > -1)
        XCTAssertEqual(batchNum+1, result)
    }
    
    func testUpdateCurrentBatchPODNUmber(){
        
        let pod = "1234"
        let service = BatchService()
        XCTAssertTrue(service.deleteAllBatches())
        let batchNum = service.createBatchWithHightestPrimaryKey()
        let result = service.updateBatchPODNUmber(pod: pod, batchNum: batchNum)
        XCTAssertTrue(result)
        
        let loadResult = service.getBatchWithBatchNum(num: batchNum)
        XCTAssertEqual(loadResult?.podNumber, pod)
        
    }
    
    func testLoadNonUploadedBatches(){
        
        let service = BatchService()
        service.deleteAllBatches()
        
        let obj1 = BatchObj()
        obj1.batchNumber = 1
        obj1.uploaded = true
        
        let obj2 = BatchObj()
        obj2.batchNumber = 2
        obj2.uploaded = false
        
        XCTAssertTrue(service.saveBatch(batch: obj1))
        XCTAssertTrue(service.saveBatch(batch: obj2))
        
        let loadResult = service.loadNonUploadedBatches()
        XCTAssertEqual(1, loadResult.count)

    }
    
    func testCreateAndUpdatePODNum(){
        
        let service = BatchService()
        XCTAssertTrue(service.deleteAllBatches())
        
        XCTAssertNotNil(service.createBatchWithHightestPrimaryKey())
        let num = service.createBatchWithHightestPrimaryKey()
        let expected = "BLAHBLAHTxt"
        let result = service.updateBatchPODNUmber(pod: expected, batchNum: num)
        let batches = service.loadNonUploadedBatches()
        let batch = batches.first
        XCTAssertEqual(2, batches.count)
        XCTAssertEqual(expected, batch?.podNumber)
        
    }
}
