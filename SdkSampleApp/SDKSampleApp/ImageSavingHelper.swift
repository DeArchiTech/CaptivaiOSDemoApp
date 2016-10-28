//
//  CSSUtilHelper.swift
//  SDKSampleApp
//
//  Created by davix on 10/28/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit

@objc class ImageSavingHelper: NSObject{
    
    class func newInstance() -> ImageSavingHelper{
        return ImageSavingHelper()
    }
    
    func saveImage(image: UIImage) -> Bool{
        
        let util = ImageUtil()
        let imageBase64Data = util.createBase64String(image: image)
        let service = CaptivaLocalImageService()
        let objc = self.createImageObj(imageBase64Data: imageBase64Data)
        service.saveImage(image: objc)
        return true
        
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
    
    func createImageObj(imageBase64Data: String) -> CaptivaLocalImageObj{
        
        let objc = CaptivaLocalImageObj()
        let num = self.getCurrentBatchNum()
        objc.batchNumber = num
        objc.imageBase64Data = imageBase64Data
        return objc
        
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
