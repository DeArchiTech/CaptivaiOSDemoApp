//
//  UploadImageObject.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import RealmSwift

class CaptivaLocalImageObj: Object{
    
    dynamic var imageBase64Data = ""
    dynamic var batchNumber = 0

    override static func primaryKey() -> String? {
        return "imagePath"
    }

}
