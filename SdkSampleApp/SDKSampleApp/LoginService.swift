//
//  LoginService.swift
//  SDKSampleApp
//
//  Created by davix on 10/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJson

@objc class LoginService: NSObject{
    
    class func newInstance() -> LoginService{
        return LoginService()
    }
    
    var endPoint: String {
        
        get {
            return "http://138.91.240.65:8090"
        }
        set {
        }
    }
    
    var cookieString: String?
    
    func createLoginObj() -> LoginRequestObj{
        
        return LoginRequestObj(licenseKey: "LICE075-D09A-64E3", applicationId: "APP3075-D09A-59C8", username: "capadmin", password: "Reva12#$")
        
    }
     
    func createLoginParam() -> Parameters{
        
        let params: Parameters = [
            "licenseKey": "LICE075-D09A-64E3",
            "applicationId": "APP3075-D09A-59C8",
            "username": "capadmin",
            "password": "Reva12#$"
        ]
        return params
        
    }
    
    func getLoginEndpoint() -> String{
        
        return endPoint + "/cp-rest/session"
    }
    
    func login(completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void {
        
        Alamofire.request(getLoginEndpoint(), method: .post, parameters: createLoginParam(), encoding: JSONEncoding.default)
            .validate()
            .responseJSON{ response in
                switch response.result{
                case .success(let result):
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        print(json)
                        completion(json, nil)
                    }
                    print("Login success")
                case .failure(let error):
                    completion(nil, error as NSError?)
                    print("Login failed")
                }
        }
    }
    
}
