//
//  EnhanceVCHelperUnitTest.swift
//  SDKSampleApp
//
//  Created by davix on 9/29/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SDKSampleApp

class EnhanceVCHelperUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveImage(){
        
        let service = CaptivaLocalImageService()
        service.deleteAllImages()
        let helper = EnhanceVCHelper()
        let filePath = "ABCDE"
        let batchNum = 1
        let result = helper.saveImage(imageLocation: filePath, batchNum: batchNum)
        XCTAssertTrue(result)
        
        let loadResult = service.loadImagesFromBatchNumber(batchNumber: batchNum)
        XCTAssertEqual(loadResult?.first?.batchNumber, batchNum)
        XCTAssertEqual(loadResult?.first?.imagePath, filePath)
    }
    
    func testGetCurrentBatchNum(){
        
        let service = BatchService()
        let batchOne = BatchObj()
        
        let expectedNumber = 3
        batchOne.batchNumber = expectedNumber
        let batchTwo = BatchObj()
        batchTwo.batchNumber = 123
        batchTwo.uploaded = true
        
        service.deleteAllBatches()
        service.saveBatch(batch: batchOne)
        service.saveBatch(batch: batchTwo)
        
        let helper = EnhanceVCHelper()
        let result = helper.getCurrentBatchNum()
        XCTAssertEqual(expectedNumber , result)
        
    }
    
    func testGetCurrentBatchNumWithNoRecord(){
        
        let service = BatchService()
        service.deleteAllBatches()
        let helper = EnhanceVCHelper()
        let result = helper.getCurrentBatchNum()
        XCTAssertEqual(0 , result)
    }
    
}
