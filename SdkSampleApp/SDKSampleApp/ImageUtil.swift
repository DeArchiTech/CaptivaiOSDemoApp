//
//  Util.swift
//  SDKSampleApp
//
//  Created by davix on 9/28/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil{
    
    init(){
        
    }
    
    func createImageUploadParam(image: UIImage) -> Dictionary<String,String>{
        let baset64String = self.createBase64String(image: image)
        let dictionary = self.createImageUploadDictionary(string: baset64String)
        return dictionary
    }
    
    func createBase64String(image : UIImage) -> String{
        let imageData:NSData = UIImageJPEGRepresentation(image,1.0)! as NSData
        let strBase64:String = imageData.base64EncodedString(options:.endLineWithCarriageReturn)
        return strBase64
    }
    
    func createImageUploadDictionary(string: String) -> Dictionary<String,String>{
        
        var result = [String: String]()
        result["data"] = string
        return result;
    }
    
}
