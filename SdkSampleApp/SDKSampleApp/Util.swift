//
//  Util.swift
//  SDKSampleApp
//
//  Created by davix on 9/28/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit

class Util{
    
    init(){
        
    }
    
    func createBase64String(image : UIImage) -> String{
        let imageData:NSData = UIImageJPEGRepresentation(image,1.0)! as NSData
        let strBase64:String = imageData.base64EncodedString(options:.endLineWithCarriageReturn)
        return strBase64
    }
    
}
