//
//  CookieManagerUnitTest.swift
//  SDKSampleApp
//
//  Created by davix on 9/27/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
@testable import SDKSampleApp

class CookieManagerUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveAndLoadCookie() {
        
        let manager : CookieManager = CookieManager.init()
        
        //1)Assert cache has no cookie
        let result : Cookie? = manager.cookieCache
        XCTAssertNil(result)

        //2)Save cookie
        let cookie = Cookie()
        cookie.cookie = "ABCDE"
        
        let saveCookieResult : Bool = manager.saveCookie(cookie: cookie)
        XCTAssertTrue(saveCookieResult)
        
        //3)Load cookie from database
        
        //4)Assert cache has cookie
    }
    
}
