//
//  MainViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/31/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import UIKit
import Foundation
import EZLoadingActivity

@objc class MainViewController: UIViewController{
    
    var batchNum : Int = 0
    
    class func newInstance() -> MainViewController{
        return MainViewController()
    }
    
    var indicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = UIActivityIndicatorView.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func scanNewPodButtonClicked(_ sender: Any) {
        
        let batchService = BatchService.init()
        self.batchNum = batchService.createBatchWithHightestPrimaryKey()
        self.pushCaptureViewController()
        
    }
    
    @IBAction func uploadPreviousBtnClicked(_ sender: Any) {
        
        self.pushUploadPreviousViewController()
        
    }
    
    func presentFailureAlertController(){
        let alertController = UIAlertController(title: "Failed to connect to server", message:
            "Please try again with a more stable internet connection", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func pushCaptureViewController(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "captureImageView") as! CaptureImageViewController
        vc.batchNum = self.batchNum
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
        
    }

    func pushUploadPreviousViewController(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadPreviousPOD") as! UploadPreviousPODViewController
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
