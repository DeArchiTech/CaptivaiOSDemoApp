//
//  UploadImageViewControllerTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import XCTest
import Foundation
@testable import SDKSampleApp

class UploadImageViewControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetPod(){
        
        let vc = UploadImageViewController()
        let expected = "helloWorld"
        vc.podNumber = UITextField.init()
        vc.podNumber.text = expected
        let actural = vc.getPod()
        XCTAssertEqual(expected,actural)
        
    }
    
    func testGetCurrentBatchNumber(){
        
        //Set Up
        let service = BatchService()
        let expected = 1
        service.deleteAllBatches()
        let batch = BatchObj()
        batch.batchNumber = 1
        service.saveBatch(batch: batch)
        
        //Test Controller
        let vc = UploadImageViewController()
        let result = vc.getCurrentBatchNumber()
        XCTAssertEqual(expected,result)
        
    }
    
    func testGetAllImageObjs() {
        //Set up
        let batchService = BatchService()
        batchService.deleteAllBatches()
        
        let service = CaptivaLocalImageService()
        service.deleteAllImages()
        
        let obj1 = CaptivaLocalImageObj()
        obj1.imagePath = "ABC"
        
        let obj2 = CaptivaLocalImageObj()
        obj2.imagePath = "DEC"
        
        let obj3 = CaptivaLocalImageObj()
        obj3.imagePath = "FASD"
        
        service.saveImage(image: obj1)
        service.saveImage(image: obj2)
        service.saveImage(image: obj3)
        
        //Test Controller
        let vc = UploadImageViewController()
        let result = vc.getAllImageObjs(num: 0)
        XCTAssertEqual(result?.count, 3)
        
    }
    
    func testUploadImage() {
        
        //Set up
        let batchService = BatchService()
        batchService.deleteAllBatches()
        let service = CaptivaLocalImageService()
        service.deleteAllImages()
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.bundlePath + "/testImg.jpg"

        let obj1 = CaptivaLocalImageObj()
        obj1.imagePath = path
        
        service.saveImage(image: obj1)
        
        //Test Controller
        let vc = UploadImageViewController()
        vc.numberOfImages = UILabel()
        vc.loadImageData()
        XCTAssertEqual(vc.imageData.count, 1)
    
    }
    
    func testIncrementNumber(){
        
        let vc = UploadImageViewController()
        vc.numberOfImages = UILabel()
        XCTAssertEqual(vc.count, 0)
        
        vc.incrementLabel()
        XCTAssertEqual(vc.count, 1)
        
    }
}
