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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, 	action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }

    @IBAction func buttonPressed(_ sender: AnyObject) {
    
        //Upload image file along with POD number attached
        //To The Json
        
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
        let paths = service.loadImagesFromBatchNumber(batchNumber: batchNum)
        return paths
        
    }
    
    func loadImageData(){
        
        let batchNum = self.getCurrentBatchNumber()
        let imageObjs = self.getAllImageObjs(num: batchNum)
        if imageObjs != nil{
            for obj in imageObjs!{
                let path = obj.imagePath
                if FileManager.default.fileExists(atPath: path){
                    let url = URL(fileURLWithPath: path)
                    let data = NSData(contentsOf: url as URL)
                    self.imageData.append(data as! Data)
                    self.incrementLabel()
                }
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
