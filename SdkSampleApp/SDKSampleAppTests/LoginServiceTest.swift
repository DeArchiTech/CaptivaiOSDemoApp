//
//  LoginServiceTest.swift
//  SDKSampleApp
//
//  Created by davix on 10/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import XCTest
@testable import SDKSampleApp

class LoginServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetEndPoint() {
        
        let manager : LoginService = LoginService.init()
        let endpoint : String = "http://138.91.240.65:8090"
        let managerEndPt : String = manager.endPoint
        XCTAssertEqual(endpoint , managerEndPt)
        
    }
    
    func testCreateLoginObject(){
        
        let manager : LoginService = LoginService.init()
        let result = manager.createLoginObj()
        XCTAssertNotNil(result)
        XCTAssertEqual("LICE075-D09A-64E3", result.licenseKey)
        XCTAssertEqual("APP3075-D09A-59C8", result.applicationId)
        XCTAssertEqual("capadmin", result.username)
        XCTAssertEqual("Reva12#$", result.password)
        
    }
    
    func testCreateLoginDictionary(){
        
        let manager : LoginService = LoginService.init()
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
        
        let manager : LoginService = LoginService.init()
        let result = manager.getLoginEndpoint()
        XCTAssertEqual(result, "http://138.91.240.65:8090/cp-rest/session" )
        
    }
    
    func testLogin() {
        
        //1)Call Function
        let manager : LoginService = LoginService.init()
        manager.login() { (dictionary,error) -> () in
            print(dictionary as Any)
            print(error as Any)
            XCTAssertNotNil(dictionary)
        }
        
    }
    
    func testGetLoginEndPt() {
        
        let expected = "http://138.91.240.65:8090/cp-rest/session"
        let manager : LoginService = LoginService.init()
        let result = manager.getLoginEndpoint()
        XCTAssertEqual(expected, result)
        
    }

}
