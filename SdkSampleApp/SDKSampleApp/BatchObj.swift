//
//  BatchObject.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import RealmSwift

class BatchObj: Object{
    
    dynamic var batchNumber = 0
    dynamic var uploaded : Bool = false
    dynamic var podNumber = ""
    var createdAt = NSDate()
    
    override static func primaryKey() -> String? {
        return "batchNumber"
    }
    
}
