//
//  UploadPreviousPODViewController.swift
//  SDKSampleApp
//
//  Created by davix on 11/2/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit
import EZLoadingActivity

@objc class UploadPreviousPODViewController: UIViewController{
    
    var connected : Bool = false
    var batches : [BatchObj] = []
    var count = 0
    var uploadHelper : UploadHelper? = nil
    
    @IBOutlet var podNumberLabel: UILabel!
    
    class func newInstance() -> UploadPreviousPODViewController{
        return UploadPreviousPODViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uploadHelper = UploadHelper.init()
        self.loadInAllBatches()
        for batches in self.batches{
            incrementNumOfPODLabel()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func uploadAllPodBtnClicked(_ sender: Any) {
        
        EZLoadingActivity.show("Uploading Documents To Server", disableUI: true)
        self.uploadAllPODBatches(batches: self.batches){
            dictionary, error in
            EZLoadingActivity.hide(true, animated: true)
            self.presentUploadSuccessController()
        }
    }
    
    func loadInAllBatches() -> Bool{
        
        let service = BatchService()
        self.batches = service.loadNonUploadedBatches()
        return true
        
    }
    
    func incrementNumOfPODLabel() -> Bool{
        
        self.count += 1
        self.podNumberLabel.text = String(self.count)
        return true
        
    }
    
    func uploadAllPODBatches(batches : [BatchObj], completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        //1)Pop array
        var dataArray = batches
        var batchObj = dataArray.popLast()
        //2)If nil we are done
        if batchObj == nil {
            completion(nil,nil)
        }else{
            //3)If not nil, call helper to upload and pass self as a call back
            self.uploadHelper?.uploadPODBatch(batchObj: batchObj!){
                dictionary, error in
                self.uploadAllPODBatches(batches: dataArray, completion: completion)
            }
        }
    }
    
     
    func presentUploadSuccessController(){
        
        let alertController = UIAlertController(title: "Upload Success", message:
            "Documents and POD Number uploaded to server successfully", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
}
