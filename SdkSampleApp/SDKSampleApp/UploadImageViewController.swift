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
//import YLProgressBar

@objc class UploadImageViewController: UIViewController{
    
    var imageData : [CaptivaLocalImageObj] = []
    var batchNum : Int = 0
    var count = 0
    var uploadhelper : UploadHelper?
//    var progress : YLProgressBar?
    
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
//        YLProgressBar.initialize()
//        self.progress = YLProgressBar.init()
//        self.progress?.type = YLProgressBarType.flat
//        self.progress?.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayMode.progress
//        self.progress?.behavior = YLProgressBarBehavior.indeterminate
//        self.progress?.stripesOrientation = YLProgressBarStripesOrientation.vertical
//        self.view.addSubview(self.progress!)
        
    }
    
    @IBAction func uploadPodBtnPressed(_ sender: Any){
        
        if checkPodNumberIsValid(){

            if hasPodToBeUploaded(){
                let service = BatchService()
                let batchObj = service.getBatchWithBatchNum(num: self.batchNum)
                service.updateBatchPODNUmber(pod: self.getPod(), batchNum: self.batchNum)
                self.chainedUploadNetworkCall(batchObj: batchObj!){
                    _,error in
                    self.uploadCompletionCode(batchObj: batchObj!, error: error)
                }
                EZLoadingActivity.show("Uploading Documents To Server", disableUI: true)
            }else{
                self.presentNoPodToBeUploadedController()
            }
        
        }
        
    }
    
    func chainedUploadNetworkCall(batchObj : BatchObj, completion: @escaping (NSDictionary?, NSError?) -> ()){
        
        self.uploadhelper = UploadHelper.init()
        self.uploadhelper?.uploadPODBatch(batchObj: batchObj){
            dictionary, error in
            completion(dictionary, error)
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
    
    func uploadCompletionCode(batchObj: BatchObj, error: NSError?) {

        if error == nil{
            let service = BatchService()
            service.updateBatchUpdatedToTrue(num: batchObj.batchNumber)
            self.uploadSuccessCode()
        }else{
            self.uploadFailureCode()
        }

    }
    
    func uploadSuccessCode() {
        EZLoadingActivity.hide(true, animated: true)
        let message = "Documents and POD Number uploaded to server successfully"
        let alertController = UIAlertController(title: "Upload Success", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func uploadFailureCode() {
        EZLoadingActivity.hide(true, animated: true)
        let message = "Upload has failed, your documents has been saved on your device and can be uploaded later"
        let alertController = UIAlertController(title: "Upload Failed", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentNoPodToBeUploadedController(){
        
        let message = "An Error have occured, please try again"
        let alertController = UIAlertController(title: "No Pod Loaded", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hasPodToBeUploaded() -> Bool{
        return self.count > 0
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
