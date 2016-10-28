//
//  BatchServiceTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/25/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import XCTest
import Foundation
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
        service.deleteAllBatches()
        service.saveBatch(batch: batch)
        let result = service.createBatchWithHightestPrimaryKey()
        XCTAssert(result > -1)
        XCTAssertEqual(batchNum+1, result)
    }
}
