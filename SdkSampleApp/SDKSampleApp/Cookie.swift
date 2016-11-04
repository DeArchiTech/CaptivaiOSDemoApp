//
//  Cookie.swift
//  SDKSampleApp
//
//  Created by davix on 9/27/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import RealmSwift

class Cookie: Object{
    
    dynamic var cookie = ""
    var createdAt = String(describing: Date())
    
    override static func primaryKey() -> String? {
        return "createdAt"
    }
    
}
