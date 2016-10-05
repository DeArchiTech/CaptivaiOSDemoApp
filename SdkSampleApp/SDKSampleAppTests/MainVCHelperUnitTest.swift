//
//  MainVCHelperUnitTest.swift
//  SDKSampleApp
//
//  Created by davix on 9/29/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SDKSampleApp

class MainVCHelperUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetCookieFromDatabase(){

        //1)Create Cookie Manager Object
        let cookieManager = CookieManager.init()
        let helper = MainVCHelper.init(cookieManager: cookieManager, service: LoginService.init())
        //1.1)Put Cookie in Database
        let cookie = Cookie.init()
        cookie.cookie = "ABC"
        cookieManager.saveCookie(cookie: cookie)
        
        //2)Assert Cookie Manager has no cookie cache
        XCTAssertNil(cookieManager.cookieCache)

        //3)Call Method to load cookie
        helper.getCookie(){ (dictionary,error) -> () in
            //Not needed
        }
        //4)Assert Cookie Manager to have cookie in cache
        XCTAssertNotNil(cookieManager.cookieCache)
        
    }
    
    func testGetCookieFromNetwork(){
        
        //1)Create Cookie Manager Object
        let cookieManager = CookieManager.init()
        let helper = MainVCHelper.init(cookieManager: CookieManager.init(), service: LoginService.init())
        
        //2)Assert Cookie Manager has no cookie cache
        XCTAssertNil(cookieManager.cookieCache)
        
        //3)Call Method to load cookie
        let readyExpectation = expectation(description: "read")
        helper.getCookie(){ (dictionary,error) -> () in
            debugPrint(dictionary)
            debugPrint(error)
            XCTAssertNotNil(dictionary)
            readyExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
    }
    
    func testGetCookieFromLoginResponse(){
        
        var cookie : String?
        //1)Get Expected String from a File
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "sampleCookie", ofType: "txt") {
            do {
                cookie = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch {
            }
        }
        
        let helper = MainVCHelper.init(cookieManager: CookieManager.init(), service: LoginService.init())
        let params: NSDictionary = [
            "returnStatus": "LICE075-D09A-64E3",
            "ticket": cookie!
        ]
        let result = helper.getcookieFromLoginResponse(response: params)
        XCTAssertEqual(params["ticket"] as! String, result)
        
    }
    
    func testPersistCookie(){
        
        //1 Create Dictionary with a cookie
        let cookie = "ABC"
        let params: NSDictionary = [
            "returnStatus": "LICE075-D09A-64E3",
            "ticket": cookie
        ]
        let helper = MainVCHelper.init(cookieManager: CookieManager.init(), service: LoginService.init())
        let result = helper.persistCookie(dictionary: params)
        XCTAssertTrue(result)
    
    }
    
    func testClearCookie(){
        
        let helper = MainVCHelper.init(cookieManager: CookieManager.init(), service: LoginService.init())
        let result = helper.clearCookie()
        XCTAssertTrue(result)
        
    }
    
    func testHasCookie(){
        
        let helper = MainVCHelper.init(cookieManager: CookieManager.init(), service: LoginService.init())
        let cookie = "ABC"
        let params: NSDictionary = [
            "returnStatus": "LICE075-D09A-64E3",
            "ticket": cookie
        ]
        
        let cookiePersisted = helper.persistCookie(dictionary: params)
        XCTAssertTrue(cookiePersisted)
        let result = helper.hasCookie()
        XCTAssertTrue(result)
        
    }
    
}
