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
        }
        
    }
    
    func testLoginEndPt(){
        
        let manager : NetworkManager = NetworkManager.init()
        let result = manager.getLoginEndpoint()
        XCTAssertEqual(result, "http://104.209.39.82:8090/cp-rest/session" )
        
    }
    
    func testLogin() {
        
        //1)Mock Up Objects
        
        //2)Call Function
        let manager : NetworkManager = NetworkManager.init();
        let response = manager.login()
        //3)Assert
    }
    
    
}
