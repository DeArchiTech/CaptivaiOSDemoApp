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
    
    @IBAction func uploadPodBtnPressed(_ sender: Any){
        
        if checkPodNumberIsValid(){

            self.chainedUploadNetworkCall(){
                _,_ in
                self.uploadCompletionCode()
            }
            EZLoadingActivity.show("Uploading Documents To Server", disableUI: true)
        
        }
        
    }
    
    func chainedUploadNetworkCall(completion: @escaping (NSDictionary?, NSError?) -> ()){
        
        //1)Create Session
        let sessionHelper = SessionHelper()
        sessionHelper.getCookie(){
            dictionary, error in
            
            //2)Create Batch
            let cookieString = sessionHelper.getCookieFromManager()?.cookie
            let networkBatchService = NetworkBatchService.init(cookie: cookieString!)
            networkBatchService.createBatch(){
                dict, error in
                
                let POD = self.podNumber.text
                let podService = PODUploadService.init(cookie: cookieString!)
                let batchID : String = networkBatchService.parseID(dictionary: dict!)
                
                //3)Upload POD NUmber
                podService.uploadPODNumber(pod: POD!, completion: { (dictionary,error) -> () in
                    if dictionary != nil {
                        
                        //4)Uplaod All The Images
                        self.uploadImagesWithCallBack(images: self.imageData, cookieString: cookieString!){
                            _,_ in
                            
                            //5)Update Batch
                            networkBatchService.updateBatch(batchId: batchID){
                                dict2,error2 in
                                completion(dict2,error2)
                            }
                        }
                    }
                })
            }
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
    
    func uploadImagesWithCallBack(images : [CaptivaLocalImageObj], cookieString : String,completion: @escaping (NSDictionary?, NSError?) -> ()){

        var data = images
        let obj = data.popLast()
        if obj != nil {
            let uploadService = UploadService.init(cookie: cookieString)
            uploadService.uploadImage(base64String: (obj?.imageBase64Data)!, completion: { (dictionary,error) -> () in
                if dictionary != nil {
                    self.uploadImagesWithCallBack(images: self.imageData, cookieString: cookieString, completion: completion)
                }
            })
        }else{
            completion(nil,nil)
        }
    }
    
    func uploadCompletionCode() {
        EZLoadingActivity.hide(true, animated: true)
        let alertController = UIAlertController(title: "Upload Success", message:
            "Documents and POD Number uploaded to server successfully", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
        
        let imageObjs = self.getAllImageObjs(num: self.batchNum)
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
