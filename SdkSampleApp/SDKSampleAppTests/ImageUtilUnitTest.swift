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
            } catch {
            }
        }
        
        //2)Compute Result using Util and Mocked Up Image

        let util = ImageUtil.init()
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        result = util.createBase64String(image : img!)
        
        let expectedIndex = expected?.index((expected?.startIndex)!, offsetBy: 10)
        let resultIndex = result?.index((result?.startIndex)!, offsetBy: 10)
        let expectedSubString = expected?.substring(to :expectedIndex!)
        let resultSubString = result?.substring(to: resultIndex!)

        //3)Assert result = expected
        XCTAssertEqual(expectedSubString, resultSubString)
        
    }
    
    func testCreateImageUploadDictionary(){
        
        var imgString : String?
        //1)Get Expected String from a File
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "base64Image", ofType: "txt") {
            do {
                imgString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch {
            }
        }
        
        let util = ImageUtil.init()
        let dictionary = util.createImageUploadDictionary(string: imgString!)
        XCTAssertNotNil(dictionary)
        XCTAssertEqual(dictionary["data"], imgString!)
        
    }
    
    func testCreateImageUploadParam(){
        
        var expected : String?
        var result : String?
        
        //1)Get Expected String from a File
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "base64Image", ofType: "txt") {
            do {
                expected = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            } catch {
                debugPrint("error")
            }
        }
        
        //2)Call method to create dictionary
        
        let util = ImageUtil.init()
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        let dictionary = util.createImageUploadParam(image: img!)
        XCTAssertNotNil(dictionary)
        result = dictionary["data"]
        
        //3)Assert substring to be the same
        let expectedIndex = expected?.index((expected?.startIndex)!, offsetBy: 10)
        let resultIndex = result?.index((result?.startIndex)!, offsetBy: 10)
        let expectedSubString = expected?.substring(to :expectedIndex!)
        let resultSubString = result?.substring(to: resultIndex!)
        
        XCTAssertEqual(expectedSubString, resultSubString)
    }
    
}
