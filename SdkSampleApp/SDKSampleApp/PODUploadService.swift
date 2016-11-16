//
//  UploadService.swift
//  SDKSampleApp
//
//  Created by davix on 10/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Alamofire

class PODUploadService{
    
    init(){
        
    }
    
    init(cookie: String){
        self.cookieString = cookie
    }
    
    var endPoint: String {
        
        get {
            return "http://138.91.240.65:8090"
        }
        set {
        }
    }
    
    var cookieString: String?
    
    func getUploadEndpoint() -> String{
        
        return endPoint + "/cp-rest/session/files"
    }
    
    func createUploadParam(pod : String) -> Dictionary<String,String>{
        
        var result = [String: String]()
        result["data"] = self.getEncodedTxtFileFromPod(pod: pod)
        result["contentType"] = "text/plain"
        return result;
        
    }
    
    func uploadPODNumber(pod: String, completion: @escaping ( _: NSDictionary?, _: NSError?)->()) -> Void{
        
        if self.cookieString != nil{
            Alamofire.request(getUploadEndpoint(), method: .post, parameters: createUploadParam(pod: pod), encoding: JSONEncoding.default, headers: self.getHeaders())
                .validate()
                .responseJSON{ response in
                    switch response.result{
                    case .success(let _):
                        if let result = response.result.value {
                            let jsonResult = result as! NSDictionary
                            completion(jsonResult, nil)
                        }
                    case .failure(let error):
                        completion(nil, error as NSError?)
                    }
            }
        }else{
            print("No cookie loaded in memory")
            completion(nil, nil)
        }
        
    }
    
    func getHeaders() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            "Authorization": self.cookieString!,
            "Accept": "application/vnd.emc.captiva+json, application/json",
            "Accept-Language": "en-US",
            "Content-Type": "application/vnd.emc.captiva+json; charset=utf-8"
        ]
        return headers
        
    }
    
    func getEncodedTxtFileFromPod(pod : String) -> String{
        
        let path = self.savePODAsTextFile(pod: pod)
        let data = self.loadTextFile(path: path!)
        return data!.base64EncodedString(options:.init(rawValue: 0))
        
    }
    
    func loadTextFile(path : String) -> NSData?{
     
        let data: NSData? = NSData(contentsOfFile: path)
        return data
        
    }
    
    func savePODAsTextFile(pod : String) -> String?{
        
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let file = pod + ".txt"
        let dir = dirs[0]//documents directory
        let path = (dir as NSString).appendingPathComponent(file);
            //writing
        do{
            try pod.write(toFile: path, atomically: false, encoding: String.Encoding.utf8);
        }catch{
                
        }
        return path
        
    }
    
}
