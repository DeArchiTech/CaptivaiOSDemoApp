//
//  NetworkManager.swift
//  SDKSampleApp
//
//  Created by davix on 9/23/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJson

@objc class NetworkManager: NSObject{
    
    class func newInstance() -> NetworkManager{
        return NetworkManager()
    }
    
    var endPoint: String {
        
        get {
            return "http://104.209.39.82:8090"
        }
        set {
        }
    }
    
    func createLoginObj() -> LoginRequestObj{
        
        return LoginRequestObj(licenseKey: "LICE075-D09A-64E3", applicationId: "APP3075-D09A-59C8", username: "capadmin", password: "Reva12#$")
        
    }
    
    func getLoginEndpoint() -> String{
        
        return endPoint + "/cp-rest/session"
    }
    

    func login() -> Void {
        
        Alamofire.request(getLoginEndpoint()).responseJSON{ (response) -> Void in
            if let JSON = response.result.value{
                print(JSON)
            }
        }
    
    }
    
}
