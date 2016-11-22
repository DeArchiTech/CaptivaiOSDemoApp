//
//  LoginService.swift
//  SDKSampleApp
//
//  Created by davix on 10/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Alamofire

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
    
    var manager: SessionManager?
    
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
                case .success(_):
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        completion(json, nil)
                    }
                case .failure(let error):
                    completion(nil, error as NSError?)
                }
        }
    }
    
    func loginWithTimeout(timeout : Int, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval.init(timeout)
        
        self.manager = Alamofire.SessionManager(configuration: configuration)
        self.manager?.request(getLoginEndpoint(), method: .post, parameters: createLoginParam(), encoding: JSONEncoding.default)
            .validate()
            .responseJSON{ response in
                switch response.result{
                case .success(_):
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        completion(json, nil)
                    }
                case .failure(let error):
                    completion(nil, error as NSError?)
                }
        }
    
    }
    
}
