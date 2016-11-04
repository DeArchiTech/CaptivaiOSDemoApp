//
//  UploadImageViewControllerTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import XCTest
import Foundation
import RealmSwift
@testable import SDKSampleApp

class UploadImageViewControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
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
    
    func testGetAllImageObjs() {
        //Set up
        let batchService = BatchService()
        batchService.deleteAllBatches()
        
        let service = CaptivaLocalImageService()
        service.deleteAllImages()
        
        let obj1 = CaptivaLocalImageObj()
        obj1.imageBase64Data = "ABC"
        
        let obj2 = CaptivaLocalImageObj()
        obj2.imageBase64Data = "DEC"
        
        let obj3 = CaptivaLocalImageObj()
        obj3.imageBase64Data = "FASD"
        
        service.saveImage(image: obj1)
        service.saveImage(image: obj2)
        service.saveImage(image: obj3)
        
        //Test Controller
        let vc = UploadImageViewController()
        let result = vc.getAllImageObjs(num: 0)
        XCTAssertEqual(result?.count, 3)
        
    }
    
    func testLoadImage() {
        
        //Set up
        let batchService = BatchService()
        batchService.deleteAllBatches()
        let service = CaptivaLocalImageService()
        service.deleteAllImages()
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.bundlePath + "/testImg.jpg"

        let obj1 = CaptivaLocalImageObj()
        obj1.imageBase64Data = path
        
        let obj2 = CaptivaLocalImageObj()
        obj2.imageBase64Data = path + "someting"
        
        service.saveImage(image: obj1)
        service.saveImage(image: obj2)
        
        //Test Controller
        let vc = UploadImageViewController()
        vc.numberOfImages = UILabel()
        vc.loadImageData()
        XCTAssertEqual(vc.imageData.count, 2)
    
    }
    
    func testIncrementNumber(){
        
        let vc = UploadImageViewController()
        vc.numberOfImages = UILabel()
        XCTAssertEqual(vc.count, 0)
        
        vc.incrementLabel()
        XCTAssertEqual(vc.count, 1)
        
    }
    
    func testUploadAllImages(){

        let vc = UploadImageViewController()
        let array : [CaptivaLocalImageObj] = []
        let exp = expectation(description: "read")
        
        //2)Call Upload Service to upload with POD number

        let sessionHelper = SessionHelper()
        sessionHelper.getCookie(){
            dictionary, error in
            let cookie = sessionHelper.getCookieFromManager()?.cookie
            let result = vc.uploadAllImages(images: array, cookieString: cookie!)
            exp.fulfill()
        }
        waitForExpectations(timeout: 60, handler: { error in
        XCTAssertNil(error, "Error")
        })
    }
    
    func testPodNumberIsValid(){
        
        let vc = UploadImageViewController()
        vc.podNumber = UITextField.init()
        vc.podNumber.text = "ABCDE"
        let result = vc.podNumberIsValid()
        XCTAssertTrue(result)
        
    }
    
    func testCheckPodNumberIsValid(){
        
        let vc = UploadImageViewController()
        vc.podNumber = UITextField.init()
        vc.podNumber.text = "ABCDE"
        let result = vc.checkPodNumberIsValid()
        XCTAssertTrue(result)
        
    }
}
