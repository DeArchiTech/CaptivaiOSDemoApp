//
//  UtilUnitTest.swift
//  SDKSampleApp
//
//  Created by davix on 9/28/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import XCTest
@testable import SDKSampleApp

class UtilUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateBase64EncodingString(){
        var expected : String?
        var result : String?
        
        //1)Get Expected String from a File
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "base64Image", ofType: "txt") {
            do {
                expected = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                debugPrint(expected)
            } catch {
                debugPrint("error")
            }
        }
        
        //2)Compute Result using Util and Mocked Up Image

        let util = Util.init()
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        result = util.createBase64String(image : img!)
        
        let expectedIndex = expected?.index((expected?.startIndex)!, offsetBy: 100)
        let resultIndex = result?.index((result?.startIndex)!, offsetBy: 100)
        let expectedSubString = expected?.substring(to :expectedIndex!)
        let resultSubString = result?.substring(to: resultIndex!)

        //3)Assert result = expected
        XCTAssertEqual(expectedSubString, resultSubString)
        
    }
    
}
