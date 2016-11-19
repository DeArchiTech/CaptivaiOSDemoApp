//
//  UploadHelper.swift
//  SDKSampleApp
//
//  Created by davix on 11/3/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation

class UploadHelper: NSObject{
    
    var sessionHelper : SessionHelper
    var podUploadService : PODUploadService?
    var uploadService : UploadService?
    var batchService : NetworkBatchService?
    
    var filesID : [String : String] = [:]
    var timeout : Int = Constants.timeout
    
    override init(){
        self.sessionHelper = SessionHelper.init()
    }
    
    init(sessionHelper : SessionHelper){
        self.sessionHelper = sessionHelper
    }
    
    func uploadPODBatch(batchObj : BatchObj ,completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        //1)Creat a session
        self.createSession(){
            dictionary1, error1 in
            self.checkForError(error: error1, completion: completion)
            
            //1.1)Create a batch
            let cookie = self.sessionHelper.getCookieStringFromManager()!
            self.createBatch(cookie: cookie){
                dict, error in
                self.checkForError(error: error, completion: completion)
                let service = NetworkBatchService.init(cookie: cookie)
                let batchID = service.parseID(dictionary: dict!)
                
                //2)Upload POD Number
                self.uploadPODNumber(podNumber: batchObj.podNumber){
                    dict2, error2 in
                    self.checkForError(error: error2, completion: completion)
                    
                    //3)Upload all Images associated with the POD
                    let service = CaptivaLocalImageService()
                    let num = batchObj.batchNumber
                    let images = service.loadImagesFromBatchNumber(batchNumber: num)
                    if images != nil{
                        self.uploadAllImages(images: images!){
                            dict3, error3 in
                            self.checkForError(error: error3, completion: completion)
                            
                            //3.1 Update The Batch
                            self.updateBatch(batchID: batchID, cookie: cookie, value: self.filesID){
                                dict4, error4 in
                                self.checkForError(error: error3, completion: completion)
                                completion(dict4, error4)
                            }
                        }
                    }else{
                        completion(dict2,NSError.init())
                    }
                }
            }
        }
    }
    
    func createBatch(cookie: String, completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        let cookie = self.sessionHelper.getCookieStringFromManager()
        self.batchService = NetworkBatchService.init(cookie: cookie!)
        self.batchService?.createBatchWithTimeOut(timeout: self.timeout){
            dictionary, error in
            completion(dictionary, error)
        }
        
    }
    
    func updateBatch(batchID: String,cookie: String,value:[String:String],completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        let cookie = self.sessionHelper.getCookieStringFromManager()
        self.batchService = NetworkBatchService.init(cookie: cookie!)
        self.batchService?.updateBatchWithTimeOut(timeout: self.timeout, batchId: batchID, value: value){
            dictionary, error in
            completion(dictionary, error)
        }
        
    }
    
    func createSession(completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        self.sessionHelper.getCookie(){
            dictionary,error in
            completion(dictionary,error)
        }
        
    }
    
    func uploadPODNumber(podNumber: String, completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        let cookieString = self.sessionHelper.getCookieFromManager()
        self.podUploadService = PODUploadService.init(cookie: (cookieString?.cookie)!)
        self.podUploadService?.uploadPODNumber(timeout: self.timeout, pod: podNumber){
            dictionary, error in
            let dict = dictionary! as NSDictionary
            self.filesID[self.parseID(dictionary: dict)] = "txt"
            completion(dictionary,error)
        }
        
    }
    
    func uploadAllImages(images : [CaptivaLocalImageObj], completion: @escaping (_: NSDictionary?, _:NSError?)->()){
        
        var imgData = images
        let img = imgData.popLast()
        if img != nil {
            self.uploadImage(image: img!){
                dictionary, error in
                self.uploadAllImages(images: imgData, completion: completion)
            }
        }else{
            completion(nil, nil)
        }
        
    }
    
    func uploadImage(image : CaptivaLocalImageObj, completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        let cookieString = self.sessionHelper.getCookieFromManager()
        self.uploadService = UploadService.init(cookie: (cookieString?.cookie)!)
        self.uploadService?.uploadImage(timeout: self.timeout, base64String: image.imageBase64Data){
            dictionary, error in
            let dict = dictionary! as NSDictionary
            let key = self.parseID(dictionary: dict)
            self.filesID[key] = "jpg"
            completion(dictionary,error)
        }
        
    }
    
    func parseID(dictionary : NSDictionary) -> String{
        
        return dictionary["id"] as! String
        
    }
    
    func checkForError(error : NSError?, completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        if hasError(error: error){
            completion(nil, error)
        }
    }
    
    func hasError(error : NSError?) -> Bool{
        return error != nil
    }
    
}
