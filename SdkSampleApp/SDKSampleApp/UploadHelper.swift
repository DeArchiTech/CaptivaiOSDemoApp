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
    var filesID : [String : String] = [:]
    
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
            //1.1)Create a batch
            let cookie = self.sessionHelper.getCookieStringFromManager()!
            self.createBatch(cookie: cookie){
                dict, error in
                let service = NetworkBatchService.init(cookie: cookie)
                let batchID = service.parseID(dictionary: dict!)
                //2)Upload POD Number
                self.uploadPODNumber(podNumber: batchObj.podNumber){
                    dict2, error2 in
                    //3)Upload all Images associated with the POD
                    let service = CaptivaLocalImageService()
                    let num = batchObj.batchNumber
                    let images = service.loadImagesFromBatchNumber(batchNumber: num)
                    if images != nil{
                        self.uploadAllImages(images: images!){
                            dict3, error3 in
                            //3.1 Update The Batch
                            self.updateBatch(batchID: batchID, cookie: cookie, value: self.filesID){
                                dict4, error4 in
                                completion(dict4, error4)
                            }
                        }
                    }else{
                        completion(dict2,error2)
                    }
                    
                }
            }
        }
    }
    
    func createBatch(cookie: String, completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        let cookie = self.sessionHelper.getCookieStringFromManager()
        let service = NetworkBatchService.init(cookie: cookie!)
        service.createBatch(){
            dictionary, error in
            completion(dictionary, error)
        }
        
    }
    
    func updateBatch(batchID: String,cookie: String,value:[String:String],completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        let cookie = self.sessionHelper.getCookieStringFromManager()
        let service = NetworkBatchService.init(cookie: cookie!)
        service.updateBatch(batchId: batchID, value: value){
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
        let service = PODUploadService.init(cookie: (cookieString?.cookie)!)
        service.uploadPODNumber(pod: podNumber){
            dictionary, error in
            let dict = dictionary! as NSDictionary
            self.filesID[self.parseID(dictionary: dict)] = "OcrDataCache" 
            completion(dictionary,error)
        }
        
    }
    
    func uploadAllImages(images : [CaptivaLocalImageObj], completion: @escaping (_: NSDictionary?, _:NSError?)->()){
        
        var imgData = images
        var img = imgData.popLast()
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
        let service = UploadService.init(cookie: (cookieString?.cookie)!)
        service.uploadImage(base64String: image.imageBase64Data){
            dictionary, error in
            let dict = dictionary! as NSDictionary
            let index = self.filesID.count
            let key = self.parseID(dictionary: dict)
            self.filesID[key] = "OutputImage"
            completion(dictionary,error)
        }
        
    }
    
    func parseID(dictionary : NSDictionary) -> String{
        
        return dictionary["id"] as! String
        
    }
    
}
