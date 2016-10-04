//
//  UploadServiceTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import XCTest
@testable import SDKSampleApp

class UploadServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetUploadImageEndPt() {
        
        let expected = "http://104.209.39.82:8090/cp-rest/session/files"
        let manager = UploadService.init()
        let result = manager.getUploadImageEndpoint()
        XCTAssertEqual(expected, result)
        
    }
    
    func testUploadImage(){
        
        //Mock Cookie
        var cookie : String?
        //1)Get Expected Cookie from a File
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "sampleCookie", ofType: "txt") {
            do {
                cookie = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch {
            }
        }
        
        let manager = UploadService.init()
        manager.cookieString = cookie
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        
        let readyExpectation = expectation(description: "read")
        manager.uploadImage(image: img!) { (dictionary,error) -> () in
            debugPrint(dictionary)
            debugPrint(error)
            XCTAssertNotNil(dictionary)
            readyExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testGetHeaders(){
        
        let headerString = "testHeader"
        let service = UploadService.init(cookie: headerString)
        let headers = service.getHeaders()
        XCTAssertEqual(headers["Authorization"] , headerString)
        XCTAssertEqual(headers["Accept"] , "application/vnd.emc.captiva+json, application/json")
        XCTAssertEqual(headers["Accept-Language"] , "en-US")
        XCTAssertEqual(headers["Content-Type"] , "application/vnd.emc.captiva+json; charset=utf-8")
        
    }
    
}
