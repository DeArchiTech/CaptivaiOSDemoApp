//
//  UploadPreviousPODVCTest.swift
//  SDKSampleApp
//
//  Created by davix on 11/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift
@testable import SDKSampleApp

class UploadPreviousPODVCTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadInAllBatches(){
        
        let vc = UploadPreviousPODViewController()
        let bs = BatchService()
        assert(bs.deleteAllBatches())
        
        let obj1 = BatchObj()
        obj1.uploaded = false
        assert(bs.saveBatch(batch: obj1))
        
        let result = vc.loadInAllBatches()
        XCTAssertTrue(result)
        XCTAssertTrue(vc.batches.count > 0)
        
    }

    func testUploadAllBatches(){
        
        //Set up View Controller
        let vc = UploadPreviousPODViewController()
        let exp = expectation(description: "read")
        
        //Set up batch
        let bs = BatchService()
        assert(bs.deleteAllBatches())
        
        let obj1 = BatchObj()
        obj1.uploaded = false
        obj1.podNumber = "ABCDE"
        assert(bs.saveBatch(batch: obj1))
        
        let obj2 = BatchObj()
        obj2.uploaded = false
        obj2.podNumber = "ASDA"
        obj2.batchNumber = 2
        assert(bs.saveBatch(batch: obj2))
        
        //Set up img and service
        let imageService = CaptivaLocalImageService()
        assert(imageService.deleteAllImages())
        let testBundle = Bundle(for: type(of: self))
        let util = ImageUtil.init()
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        let img2 = UIImage(named: "testImg2.jpg", in: testBundle, compatibleWith: nil)
        let imageObj = CaptivaLocalImageObj()
        imageObj.batchNumber = obj1.batchNumber
        imageObj.imageBase64Data = util.createBase64String(image : img!)
        assert(imageService.saveImage(image: imageObj))
        let imageObj2 = CaptivaLocalImageObj()
        imageObj2.batchNumber = obj2.batchNumber
        imageObj2.imageBase64Data = util.createBase64String(image : img2!)
        assert(imageService.saveImage(image: imageObj2))
        
        XCTAssertTrue(vc.loadInAllBatches())
        //Call Upload Code
        vc.uploadAllPODBatches(batches: vc.batches){
            (dictionary,error) -> ()in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 60, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
}
