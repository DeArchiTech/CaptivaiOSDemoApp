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
import EZLoadingActivity

@objc class UploadImageViewController: UIViewController{
    
    var imageData : [CaptivaLocalImageObj] = []
    var count = 0
    var connected : Bool = false
    
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
    
    @IBAction func uploadPodBtnPressed(_ sender: Any) {
        
        if checkPodNumberIsValid(){
            //Upload a text file with the POD Number in it
            let POD = self.podNumber.text
            self.service?.uploadPODNumber(pod: POD!, completion: { (dictionary,error) -> () in
                if dictionary != nil {
                    self.uploadAllImages(images: self.imageData)
                }
            })
            EZLoadingActivity.show("Uploading Documents To Server", disableUI: true)
        }
        
    }
    
    @IBAction func savePodBtnPressed(_ sender: Any) {

        if checkPodNumberIsValid(){
            //Upload a text file with the POD Number in it
            let POD = self.podNumber.text
            let batch = BatchService()
            let alertController = UIAlertController(title: "POD Number Saved", message:
                "POD Number and Documents saved and can be uploaded later", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
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
            EZLoadingActivity.hide(true, animated: true)
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
    
    func checkPodNumberIsValid() -> Bool{
        
        if !podNumberIsValid(){
            let alertController = UIAlertController(title: "POD Number Error", message:
                "Please insert a valid POD Number", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    func podNumberIsValid() -> Bool{
        
        let pod = getPod()
        return pod.characters.count > 0
    
    }
    
}
