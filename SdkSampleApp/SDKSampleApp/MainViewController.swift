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
    
    class func newInstance() -> MainViewController{
        return MainViewController()
    }
    
    var indicator : UIActivityIndicatorView!
    var connected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = UIActivityIndicatorView.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func scanNewPodButtonClicked(_ sender: Any) {
        
        let helper = MainVCHelper()
        helper.getCookie(){ dictionary,error in
            EZLoadingActivity.hide(true, animated: true)
            
            self.connected = dictionary != nil
            helper.persistCookie(dictionary: dictionary)
            self.scanPodBtnCompletion()
        }
        EZLoadingActivity.show("Connecting to server...", disableUI: true)
        
    }
    
    func scanPodBtnCompletion(){
        let batchService = BatchService.init()
        batchService.createBatchWithHightestPrimaryKey()
        EZLoadingActivity.hide(true, animated: true)
        self.pushCaptureViewController()
    }
    
    @IBAction func uploadPreviousBtnClicked(_ sender: Any) {
        
        let helper = MainVCHelper()
        helper.getCookie(){ dictionary,error in
            EZLoadingActivity.hide(true, animated: true)
            
            self.connected = dictionary != nil
            helper.persistCookie(dictionary: dictionary)
            
            self.uploadPreviousBtnCompletion(connected: self.connected)
        }
        EZLoadingActivity.show("Connecting to server...", disableUI: true)
        
    }
    
    func uploadPreviousBtnCompletion(connected : Bool){
        
        if connected {
            let batchService = BatchService.init()
            batchService.createBatchWithHightestPrimaryKey()
            EZLoadingActivity.hide(true, animated: true)
            self.pushUploadPreviousViewController()
        }else{
            self.presentFailureAlertController()
        }
        
    }
    
    func presentFailureAlertController(){
        let alertController = UIAlertController(title: "Failed to connect to server", message:
            "Please try again with a more stable internet connection", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func pushCaptureViewController(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "captureImageView") as! CaptureImageViewController
        vc.connected = self.connected
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
        
    }

    func pushUploadPreviousViewController(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadPreviousPOD") as! UploadPreviousPODViewController
        vc.connected = self.connected
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
