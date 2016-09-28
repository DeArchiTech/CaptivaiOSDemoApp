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
    
    func createLoginParam() -> Parameters{
        
        let params: Parameters = [
            "licenseKey": "LICE075-D09A-64E3",
            "applicationId": "APP3075-D09A-59C8",
            "username": "capadmin",
            "password": "Reva12#$"
        ]
        return params
        
    }
    
    func getcookieFromLoginResponse(response : NSDictionary) -> String{
        
        return response["ticket"] as! String
        
    }
    
    func getLoginEndpoint() -> String{
        
        return endPoint + "/cp-rest/session"
    }
    
    func getUploadImageEndpoint() -> String{
        
        return endPoint + "/cp-rest/session/files"
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
    
    func uploadImage(image: UIImage, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void {
        
        
    }
    
}
