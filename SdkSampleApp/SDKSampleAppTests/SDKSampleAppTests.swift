//
//  SDKSampleAppTests.swift
//  SDKSampleAppTests
//
//  Created by davix on 9/23/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
@testable import SDKSampleApp

class SDKSampleAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        //var manager :
        var manager : NetworkManager = NetworkManager.init()
        var endpoint : String = "http://104.209.39.82:8090"
        var managerEndPt : String = manager.endPoint
        XCTAssertEqual(endpoint , managerEndPt)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
