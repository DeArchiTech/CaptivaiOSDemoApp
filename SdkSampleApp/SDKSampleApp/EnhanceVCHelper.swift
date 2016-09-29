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
        self.networkManager = NetworkManager.init()
    }
    
    var cookieManager : CookieManager?
    var networkManager : NetworkManager?
    
    func uploadImage(image: UIImage, completion: @escaping ( _: NSDictionary?, _:NSError?)-> ()) -> Void{
        
        self.networkManager?.uploadImage(image: image, completion: completion)
        
    }
    
    func displayUploadResult(jsonResult : Dictionary<String, Any>?, error : NSError) -> Bool{
        
        if jsonResult != nil{
            displayUploadSuccess(jsonResult: jsonResult!)
            return true
        }else if error != nil{
            displayUploadError(error: error)
        }
        return false
    }
    
    func displayUploadSuccess(jsonResult : Dictionary<String, Any>){
        
        //Todo Implement, print something to the screen
        let alertTitle = "Upload Success"
        let alertMessage = "Image uploaded to server successfully"
        CSSUtils.showAlert(withMessage: alertMessage, title: alertTitle)
        
    }
    
    func displayUploadError(error : NSError){
    
        //Todo Implement, print something to the screenß
        let errorTitle = "Upload Failed"
        CSSUtils.showAlert(onError: error, title: errorTitle)
        
    }
    
}
