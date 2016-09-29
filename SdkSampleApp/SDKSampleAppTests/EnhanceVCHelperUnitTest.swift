//
//  EnhanceVCHelperUnitTest.swift
//  SDKSampleApp
//
//  Created by davix on 9/29/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
@testable import SDKSampleApp

class EnhanceVCHelperUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDisplayUploadResultSuccess(){
        
        
    }
    
    func testDisplayUploadResultFail(){
        
        let helper = EnhanceVChelper.init()
        let dictionary = nil
        let error = NSError.init()
        let result = helper.displayUploadResult(jsonResult: dictionary, error: error)
        XCTAssertTrue(result)
        
    }
    
    func testUploadImage() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
