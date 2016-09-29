//
//  MainVCHelper.swift
//  SDKSampleApp
//
//  Created by davix on 9/29/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation

@objc class MainVCHelper: NSObject{
    
    class func newInstance() -> NetworkManager{
        return NetworkManager()
    }
    
    init(cookieManager : CookieManager, networkManager : NetworkManager){
        self.cookieManager = cookieManager
        self.networkManager = networkManager
    }
    
    override init(){
        self.cookieManager = CookieManager.init()
        self.networkManager = NetworkManager.init()
    }
    
    var cookieManager : CookieManager?
    var networkManager : NetworkManager?
    
    func getCookie(completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void {
        
        //1)Attempt to load from Database
        let result = self.cookieManager?.loadCookie()
        if result == false{
            self.networkManager?.login(completion:completion)
        }
    }
    
    func persistCookie(dictionary : NSDictionary?) -> Bool {
        
        if dictionary != nil {
            
            //Get Cookie String
            let cookieString = self.getcookieFromLoginResponse(response: dictionary!)
            let cookie = Cookie.init()
            cookie.cookie = cookieString
            
            //Save Cookie to Database
            self.cookieManager?.saveCookie(cookie: cookie)
            self.cookieManager?.cookieCache = cookie
            return true
        }
        return false
    }
    
    func getcookieFromLoginResponse(response : NSDictionary) -> String{
        
        return response["ticket"] as! String
        
    }
    
}
