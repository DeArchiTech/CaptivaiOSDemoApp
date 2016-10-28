//
//  UploadImageViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/21/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import UIKit
import Foundation
import Photos

@objc class UploadImageViewController: UIViewController{
    
    var imageData : [Data] = []
    var count = 0
    @IBOutlet var numberOfImages: UILabel!
    @IBOutlet var podNumber: UITextField!
    
    class func newInstance() -> UploadImageViewController{
        return UploadImageViewController()
    }
    
    var cookieManager : CookieManager?
    var service : PODUploadService?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, 	action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.cookieManager = CookieManager.init()
        if(self.cookieManager?.loadCookie())!{
            let cookieString = self.cookieManager?.cookieCache?.cookie
            self.service = PODUploadService.init(cookie: cookieString!)
        }else{
            print("Error, cannot load cookie cache")
        }
        
    }

    @IBAction func buttonPressed(_ sender: AnyObject) {
    
        //1)Upload All The Images that hasn't been uploaded
        
        //2)Upload a text file with the POD Number in it
        let POD = self.podNumber.text
        self.service?.uploadPODNumber(pod: POD!, completion: { (dictionary,error) -> () in
            print(dictionary)
            print(error)
            }
        )
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    
    func getPod() -> String{
        
        return self.podNumber.text!
        
    }
    
    func getCurrentBatchNumber() -> Int{
    
        let service = BatchService()
        return service.getCurrentBatchNum()
        
    }
    
    func getAllImageObjs(num : Int) -> [CaptivaLocalImageObj]?{
        
        let batchNum = self.getCurrentBatchNumber()
        let service = CaptivaLocalImageService()
        let imgObjs = service.loadImagesFromBatchNumber(batchNumber: batchNum)
        return imgObjs
        
    }
    
    func loadImageData(){
        
        let batchNum = self.getCurrentBatchNumber()
        let imageObjs = self.getAllImageObjs(num: batchNum)
        if imageObjs != nil{
            for obj in imageObjs!{
                self.incrementLabel()
            }
        }
    }
    
    func incrementLabel(){
        
        self.count += 1
        self.numberOfImages.text = String(self.count)
        
    }
    
    func uploadImage(data : NSData,completion: @escaping (NSDictionary?, NSError?) -> ()){
        
        let service = UploadService()
        service.uploadImage(data: data, completion: completion)
    }
    
}
