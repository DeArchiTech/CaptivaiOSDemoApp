//
//  MainVCHelper.swift
//  SDKSampleApp
//
//  Created by davix on 9/29/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit

@objc class SessionHelper: NSObject{
    
    class func newInstance() -> SessionHelper{
        return SessionHelper()
    }
    
    init(cookieManager : CookieManager, service : LoginService){
        self.cookieManager = cookieManager
        self.loginService = service
    }
    
    override init(){
        self.cookieManager = CookieManager.init()
        self.loginService = LoginService.init()
    }
    
    var cookieManager : CookieManager?
    var loginService : LoginService?
    var timeout : Int = Constants.timeout
    
    func getCookieExpress(completion: @escaping ( _: String?) -> ()) ->Void {
     
        //1)Attempt to load from Database
        self.loginService?.login(){dictionary, error in
            if error == nil{
                let cookieString = self.getcookieFromLoginResponse(response: dictionary!)
                let cookie = Cookie.init()
                cookie.cookie = cookieString
                self.cookieManager?.cookieCache = cookie
                completion(cookie.cookie)
            }else{
                completion("")
            }

        }
        
    }
    
    func getCookie(completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void {
        
        //1)Attempt to load from Database
        self.loginService?.loginWithTimeout(timeout: self.timeout){
            dictionary, error in
            if error == nil{
                let cookieString = self.getcookieFromLoginResponse(response: dictionary!)
                let cookie = Cookie.init()
                cookie.cookie = cookieString
                self.cookieManager?.cookieCache = cookie
            }
            completion(dictionary,error)
        }
        
    }
    
    func getCookieStringFromManager() -> String?{
        
        return self.cookieManager?.cookieCache?.cookie
        
    }
    
    func getCookieFromManager() -> Cookie?{
        
        return self.cookieManager?.cookieCache
        
    }
    
    func persistCookie(dictionary : NSDictionary?) -> Bool {
        
        if dictionary != nil {
            //Save Cookie to Database'
            let cookie = Cookie.init()
            let cookieString = self.getcookieFromLoginResponse(response: dictionary!)
            cookie.cookie = cookieString
            self.cookieManager?.saveCookie(cookie: cookie)
            return true
        }
        return false
    }
    
    func getcookieFromLoginResponse(response : NSDictionary) -> String{
        
        return response["ticket"] as! String
        
    }
    
    func clearCookie() -> Bool{
        
        return self.cookieManager!.clearAllCookies()
        
    }
    
    func hasCookie() -> Bool{
        
        let result = self.cookieManager?.loadCookie()
        return result!
        
    }
    
    func createNewBatch() -> Int{
        
        let service = BatchService()
        return service.createBatchWithHightestPrimaryKey()
        
    }

}
