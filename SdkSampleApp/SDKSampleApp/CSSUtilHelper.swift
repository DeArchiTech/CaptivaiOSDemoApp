//
//  CSSUtilHelper.swift
//  SDKSampleApp
//
//  Created by davix on 10/28/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit

@objc class CSSUtilHelper: NSObject{
    
    class func newInstance() -> CSSUtilHelper{
        return CSSUtilHelper()
    }
    
    func saveImage(data: NSData, imagePath: NSString) -> Bool{
        
        let imageBase64Data = self.getBase64Data(data: data)
        let service = CaptivaLocalImageService()
        let objc = self.createImageObj(imageBase64Data: imageBase64Data, imagePath: imagePath as String)
        service.saveImage(image: objc)
        return true
        
    }
    
    func getBase64Data(data: NSData) -> String{
        
        let util = ImageUtil()
        return util.createBase64String(data: data)
        
    }
    
    func createImageObj(imageBase64Data: String, imagePath: String) -> CaptivaLocalImageObj{
        
        let objc = CaptivaLocalImageObj()
        let num = self.getCurrentBatchNum()
        objc.batchNumber = num
        objc.imageBase64Data = imageBase64Data
        objc.imagePath = imagePath
        return objc
        
    }
    
    func getCurrentBatchNum() -> Int{
        
        let service = BatchService()
        let number = service.getCurrentBatchNum()
        return number
        
    }

}
