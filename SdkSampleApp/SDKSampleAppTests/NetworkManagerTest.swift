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
    
    func testGetCookieFromLoginResponse(){
        
        let manager : NetworkManager = NetworkManager.init()
        let params: NSDictionary = [
            "returnStatus": "LICE075-D09A-64E3",
            "ticket": "SK22>>>>*!9839908084640907461/pedn3xK0Yw7TVPt+oLguhB/TQkr9CZEOoN5F3WvKcx75JaQaZ+pnqj6V/iGCRdQ1acNZuQyMx0reNZ5BIqU0lx9s4lmwPdOmf95riSEqkz6MDJfrUYV/6XBbw0XvSqTCULNg3+YonCW+ETH+H/9ux78Ngn3TTSPGWeFW0fBN2maM4XSaJrpWMLg9zB+A7X/AL6QXeMcF7VbKoRCRYtFTJp1g51s4rB/+a8SlEbgdrRF46VLxQJvvVNs0ixV8ijPeOmXkQasrne113jXhKVvDOcAlmPpLyiGKF3XISKFV3LYnyg==*>>>>"
        ]
        let result = manager.getcookieFromLoginResponse(response: params)
        XCTAssertEqual(params["ticket"] as! String, result)
        
    }
    
    func testLogin() {
        
        //1)Call Function
        let manager : NetworkManager = NetworkManager.init();
        manager.login() { (dictionary,error) -> () in
            print(dictionary)
            print(error)
            XCTAssertTrue(true)
        }
        
    }
    
    
}
