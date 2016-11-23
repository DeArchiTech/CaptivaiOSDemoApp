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

@objc class UploadPreviousPODViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    var connected : Bool = false
    var batches : [BatchObj] = []
    var count = 0
    var helper : UploadHelper?
    var service : BatchService?
    
    @IBOutlet var podNumberLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    class func newInstance() -> UploadPreviousPODViewController{
        return UploadPreviousPODViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInAllBatches()
        self.setUpLabel()
    }
    
    func setUpLabel(){
        
        let count = self.batches.count
        self.podNumberLabel.text = String(count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func uploadAllPodBtnClicked(_ sender: Any) {
        
        if self.hasPodToBeUploaded(){
            EZLoadingActivity.show("Uploading Documents To Server", disableUI: true)
            self.uploadAllPODBatches(batches: self.batches   ){
                dictionary, error in
                EZLoadingActivity.hide(true, animated: true)
                if error == nil{
                    self.loadInAllBatches()
                    self.setUpLabel()
                    self.tableView.reloadData()
                    self.presentUploadSuccessController()
                }else{
                    self.presentUploadFailureController()
                }
                
            }
        }else{
            self.presentNoPodToBeUploadedController()
        }

    }
    
    func loadInAllBatches() -> Bool{
        
        let service = BatchService()
        self.batches = service.loadNonUploadedBatches()
        return true
        
    }
    
    func uploadAllPODBatches(batches : [BatchObj], completion: @escaping ( _: NSDictionary?, _: NSError?)->()){
        
        //1)Pop array
        var dataArray = batches
        let batchObj = dataArray.popLast()
        //2)If nil we are done
        if batchObj == nil {
            completion(nil,nil)
        }else{
            //3)If not nil, call helper to upload and pass self as a call back
            self.helper = UploadHelper.init()
            self.helper?.uploadPODBatch(batchObj: batchObj!){
                dictionary, error in
                if error == nil{
                    self.uploadAllPODBatches(batches: dataArray, completion: completion)
                }else{
                    completion(dictionary, error)
                }

            }
        }
    }
     
    func presentUploadSuccessController(){
        
        let alertController = UIAlertController(title: "Upload Success", message:
            "Documents and POD Number uploaded to server successfully", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func presentUploadFailureController(){
        
        let message = "Upload has failed, please try again with a more stable internet connection"
        let alertController = UIAlertController(title: "Upload Failed", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func presentNoPodToBeUploadedController(){
        
        let message = "There is no pending PODs to be Uploaded"
        let alertController = UIAlertController(title: "No Pod Loaded", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.batches.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        if( indexPath.item == 0){
            cell.textLabel?.text = "POD Number #"
        }else{
            var index = indexPath.item
            index -= 1
            let batch = self.batches[index]
            let text = batch.podNumber
            cell.textLabel?.text = text
        }
        return cell
        
    }
    
    func hasPodToBeUploaded() -> Bool{
        return self.batches.count > 0
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
}
