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
    var batchNum : Int = 0
    var count = 0
    
    @IBOutlet var numberOfImages: UILabel!
    @IBOutlet var podNumber: UITextField!
    
    class func newInstance() -> UploadImageViewController{
        return UploadImageViewController()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, 	action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.loadImageData()
        
    }
    
    @IBAction func uploadPodBtnPressed(_ sender: Any) {
        
        if checkPodNumberIsValid(){
            //Upload a text file with the POD Number in it
            let sessionHelper = SessionHelper()
            sessionHelper.getCookie(){
                dictionary, error in
    
                let cookieString = sessionHelper.getCookieFromManager()?.cookie
                let POD = self.podNumber.text
                
                //Todo Implement: Add In Create Batch Code Here
                
                let podService = PODUploadService.init(cookie: cookieString!)
                podService.uploadPODNumber(pod: POD!, completion: { (dictionary,error) -> () in
                    if dictionary != nil {
                        self.uploadAllImages(images: self.imageData, cookieString: cookieString!)
                    }
                })
            }

            EZLoadingActivity.show("Uploading Documents To Server", disableUI: true)
        }
        
    }
    
    @IBAction func savePodButtonPressed(_ sender: Any) {
        
        if checkPodNumberIsValid(){
            let POD = self.podNumber.text
            let batch = BatchService()
            batch.updateBatchPODNUmber(pod: POD!, batchNum: self.batchNum)
            let alertController = UIAlertController(title: "POD Number Saved", message:
                "POD Number and Documents saved and can be uploaded later", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func uploadAllImages(images : [CaptivaLocalImageObj], cookieString : String) -> Bool{
        
        var data = images
        let obj = data.popLast()
        if obj != nil {
            let uploadService = UploadService.init(cookie: cookieString)
            uploadService.uploadImage(base64String: (obj?.imageBase64Data)!, completion: { (dictionary,error) -> () in
                if dictionary != nil {
                    self.uploadAllImages(images: self.imageData, cookieString: cookieString)
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
        
        return self.batchNum
        
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
