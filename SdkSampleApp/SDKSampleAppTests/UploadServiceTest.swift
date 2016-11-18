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
        
        let expected = "http://138.91.240.65:8090/cp-rest/session/files"
        let manager = UploadService.init()
        let result = manager.getUploadImageEndpoint()
        XCTAssertEqual(expected, result)
        
    }
    
    func testUploadImage(){
        
        let exp = expectation(description: "read")
        let sessionHelper = SessionHelper()
        sessionHelper.getCookieExpress(){
            cookie in
            
            let podUploadService = UploadService.init(cookie: cookie!)
            let testBundle = Bundle(for: type(of: self))
            let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
            let base64String = ImageUtil.init().createBase64String(image: img!)
            
            podUploadService.uploadImage(timeout: 1, base64String: base64String){
                dict, error in
                XCTAssertNil(dict)
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 60, handler: {error in
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
