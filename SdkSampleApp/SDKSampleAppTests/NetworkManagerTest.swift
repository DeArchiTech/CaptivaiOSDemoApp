//
//  SDKSampleAppTests.swift
//  SDKSampleAppTests
//
//  Created by davix on 9/23/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
@testable import SDKSampleApp

class NetworkManagerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetEndPoint() {
        
        let manager : NetworkManager = NetworkManager.init()
        let endpoint : String = "http://104.209.39.82:8090"
        let managerEndPt : String = manager.endPoint
        XCTAssertEqual(endpoint , managerEndPt)
        
    }
    
    func testCreateLoginObject(){
        
        let manager : NetworkManager = NetworkManager.init()
        let result = manager.createLoginObj()
        XCTAssertNotNil(result)
        XCTAssertEqual("LICE075-D09A-64E3", result.licenseKey)
        XCTAssertEqual("APP3075-D09A-59C8", result.applicationId)
        XCTAssertEqual("capadmin", result.username)
        XCTAssertEqual("Reva12#$", result.password)
    
    }
    
    func testCreateLoginDictionary(){
        
        let manager : NetworkManager = NetworkManager.init()
        let result = manager.createLoginParam()
        XCTAssertNotNil(result)
        if let key = result["licenseKey"] as? NSString {
            XCTAssertEqual("LICE075-D09A-64E3", key)
        }else{
            XCTAssertTrue(false)
        }
        if let key = result["applicationId"] as? NSString {
            XCTAssertEqual("APP3075-D09A-59C8", key)
        }else{
            XCTAssertTrue(false)
        }
        if let key = result["username"] as? NSString {
            XCTAssertEqual("capadmin", key)
        }else{
            XCTAssertTrue(false)
        }
        if let key = result["password"] as? NSString {
            XCTAssertEqual("Reva12#$", key)
        }else{
            XCTAssertTrue(false)
        }
    }
    
    func testLoginEndPt(){
        
        let manager : NetworkManager = NetworkManager.init()
        let result = manager.getLoginEndpoint()
        XCTAssertEqual(result, "http://104.209.39.82:8090/cp-rest/session" )
        
    }
    
    func testLogin() {
        
        //1)Call Function
        let manager : NetworkManager = NetworkManager.init()
        manager.login() { (dictionary,error) -> () in
            print(dictionary)
            print(error)
            XCTAssertNotNil(dictionary)
        }
        
    }
    
    func testGetLoginEndPt() {
        
        let expected = "http://104.209.39.82:8090/cp-rest/session"
        let manager : NetworkManager = NetworkManager.init()
        let result = manager.getLoginEndpoint()
        XCTAssertEqual(expected, result)
        
    }
    
    func testGetUploadImageEndPt() {
        
        let expected = "http://104.209.39.82:8090/cp-rest/session/files"
        let manager = NetworkManager.init()
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

        let manager = NetworkManager.init()
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
    
}
