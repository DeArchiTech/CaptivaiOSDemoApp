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
    
//    func getBase64Data(image : UIImage) -> String{
//        
//        let util = ImageUtil()
//        return util.createBase64String(image: image)
//        
//    }
//    
//    func saveImage(image: UIImage, imagePath: String) -> Bool{
//        
//        let imageBase64Data = self.getBase64Data(image: image)
//        let num = self.getCurrentBatchNum()
//        let service = CaptivaLocalImageService()
//        let objc = self.createImageObj(imageBase64Data: imageBase64Data, imagePath: imagePath)
//        service.saveImage(image: objc)
//        return true
//    }
//    
//    func createImageObj(imageBase64Data: String, imagePath: String) -> CaptivaLocalImageObj{
//    
//        let objc = CaptivaLocalImageObj()
//        let num = self.getCurrentBatchNum()
//        objc.batchNumber = num
//        objc.imageBase64Data = imageBase64Data
//        objc.imagePath = imagePath
//        return objc
//    
//    }
    

}
