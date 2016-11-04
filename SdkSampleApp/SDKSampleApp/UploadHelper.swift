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
            //2)Upload POD Number
            self.uploadPODNumber(podNumber: batchObj.podNumber){
                dictionary2, error2 in
                //3)Upload all Images associated with the POD
                let service = CaptivaLocalImageService()
                let num = batchObj.batchNumber
                let images = service.loadImagesFromBatchNumber(batchNumber: num)
                self.uploadAllImages(images: images!){
                    dictionary3, error3 in
                    completion(dictionary3, error3)
                }
            }
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
            completion(dictionary,error)
        }
        
    }
    
}
