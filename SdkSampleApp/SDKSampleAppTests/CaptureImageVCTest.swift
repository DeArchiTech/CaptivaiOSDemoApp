//
//  CaptureImageVCTest.swift
//  SDKSampleApp
//
//  Created by davix on 11/1/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import XCTest
import RealmSwift
@testable import SDKSampleApp

class CaptureImageVCTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetImageData(){
    
        let vc = CaptureImageViewController()
        //1)Load Test Image into Image View
        let testBundle = Bundle(for: type(of: self))
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        let expected: Data = UIImageJPEGRepresentation(img!,1.0)! as Data
        let imgView = UIImageView.init(image: img)
        vc.imageView = imgView
        
        //2)Call method
        let result = vc.getImageData()
        
        //3)Assert result same as expected
        XCTAssertEqual(result, expected as Data)
    }
    
    func testApplyFilterForDemo(){
        
        let vc = CaptureImageViewController()
        //1)Load Test Image into Image View
        let testBundle = Bundle(for: type(of: self))
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        let expected: Data = UIImageJPEGRepresentation(img!,1.0)! as Data
        let imgView = UIImageView.init(image: img)
        vc.imageView = imgView
        
        //2)Call Method
        vc.applyFilterForDemo(imgData: vc.getImageData())
        
    }
    
    func testPersistImgToDisk(){
        
        //1)Delete everything in DB
        let service = CaptivaLocalImageService()
        service.deleteAllImages()
        
        //2)Set up Controller Code
        let vc = CaptureImageViewController()
        let testBundle = Bundle(for: type(of: self))
        let img = UIImage(named: "testImg.jpg", in: testBundle, compatibleWith: nil)
        
        //3)Call Code
        vc.persistImgToDisk(image: img!)
        let bs = BatchService()
        let result = service.loadImagesFromBatchNumber(batchNumber: bs.getCurrentBatchNum())
        XCTAssert((result?.count)! > 0)
        
    }
}
