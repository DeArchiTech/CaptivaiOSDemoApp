//
//  NetworkBatchService.swift
//  SDKSampleApp
//
//  Created by davix on 11/7/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Alamofire

class NetworkBatchService{

    init(cookie: String){
        self.cookieString = cookie
    }
    
    var cookieString: String?
    
    let endpoint = "http://138.91.240.65:8090"
 
    func getBatchUploadEndPoint() -> String{
        
        return endpoint + "/session/batches"
        
    }
    
    func getBatch(string :String, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
     
        completion(nil,nil)
        
    }
    
    func createBatch(completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        completion(nil,nil)
        
    }
    
}
