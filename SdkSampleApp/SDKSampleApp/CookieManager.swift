//
//  CookieManager.swift
//  SDKSampleApp
//
//  Created by davix on 9/27/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import RealmSwift

@objc class CookieManager: NSObject{
    
    var cookieCache: Cookie?
    
    class func newInstance() -> CookieManager{
        return CookieManager()
    }
    
    func saveCookie(cookie: Cookie) -> Bool {
        
        try! Realm().write(){
            try! Realm().add(cookie)
        }
        return true
    
    }
    
    func loadCookie() -> Bool {
        let objs: Results<Cookie> = {
           try! Realm().objects(Cookie)
        }()
        self.cookieCache = objs.first
        return true
    
    }
    
}
