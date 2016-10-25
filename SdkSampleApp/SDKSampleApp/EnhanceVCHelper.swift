//
//  EnhanceVCHelper.swift
//  SDKSampleApp
//
//  Created by davix on 9/29/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit

@objc class EnhanceVCHelper: NSObject{
    
    class func newInstance() -> EnhanceVCHelper{
        return EnhanceVCHelper()
    }
    
    override init(){
        
        self.cookieManager = CookieManager.init()
        if(self.cookieManager?.loadCookie())!{
            let cookieString = self.cookieManager?.cookieCache?.cookie
            self.uploadService = UploadService.init(cookie: cookieString!)
        }else{
            print("Error, cannot load cookie cache")
        }

    }
    
    var cookieManager : CookieManager?
    var uploadService : UploadService?
    
    func uploadImage(image: UIImage, completion: @escaping ( _: NSDictionary?, _:NSError?)-> ()) -> Void{
        
        self.uploadService?.uploadImage(image: image, completion: completion)
        
    }
    
    func saveImage(imageLocation: String) -> Bool{
        
        let num = self.getCurrentBatchNum()
        return self.saveImage(imageLocation: imageLocation, batchNum: num)

    }
    
    func saveImage(imageLocation: String, batchNum: Int) -> Bool{
        
        let service = CaptivaLocalImageService()
        let objc = CaptivaLocalImageObj()
        objc.batchNumber = batchNum
        objc.imagePath = imageLocation
        service.saveImage(image: objc)
        return true
        
    }
    
    func getCurrentBatchNum() -> Int{
        
        let service = BatchService()
        let number = service.getCurrentBatchNum()
        return number
        
    }
    
}
