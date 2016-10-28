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
    
    var imageData : [CaptivaLocalImageObj] = []
    var count = 0
    @IBOutlet var numberOfImages: UILabel!
    @IBOutlet var podNumber: UITextField!
    
    class func newInstance() -> UploadImageViewController{
        return UploadImageViewController()
    }
    
    var cookieManager : CookieManager?
    var service : PODUploadService?
    var uploadService : UploadService?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, 	action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.cookieManager = CookieManager.init()
        if(self.cookieManager?.loadCookie())!{
            let cookieString = self.cookieManager?.cookieCache?.cookie
            self.service = PODUploadService.init(cookie: cookieString!)
            self.uploadService = UploadService.init(cookie: cookieString!)
        }else{
            print("Error, cannot load cookie cache")
        }
        self.loadImageData()
        
    }

    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        //2)Upload a text file with the POD Number in it
        let POD = self.podNumber.text
        self.service?.uploadPODNumber(pod: POD!, completion: { (dictionary,error) -> () in
            if dictionary != nil {
                self.uploadAllImages(images: self.imageData)
            }
            }
        )
    }
    
    func uploadAllImages(images : [CaptivaLocalImageObj]) -> Bool{
        
        let obj = self.imageData.popLast()
        if obj != nil {
            self.uploadService?.uploadImage(base64String: (obj?.imageBase64Data)!, completion: { (dictionary,error) -> () in
                if dictionary != nil {
                    self.uploadAllImages(images: self.imageData)
                }
            })
        }else{
            let alertController = UIAlertController(title: "Upload Success", message:
                "Documents and POD Number uploaded to server successfully", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        return true
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
        
        let service = CaptivaLocalImageService()
        let imgObjs = service.loadImagesFromBatchNumber(batchNumber: num)
        return imgObjs
        
    }
    
    func loadImageData(){
        
        let batchNum = self.getCurrentBatchNumber()
        let imageObjs = self.getAllImageObjs(num: batchNum)
        if imageObjs != nil{
            for obj in imageObjs!{
                self.incrementLabel()
                self.imageData.append(obj)
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
