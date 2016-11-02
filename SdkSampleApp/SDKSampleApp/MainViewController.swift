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
        
        self.getAndPersistCookie(){self.loginCallCompletion()}
        EZLoadingActivity.show("Connecting to server...", disableUI: true)
        
    }
    
    @IBAction func uploadPreviousBtnClicked(_ sender: Any) {
        
    }
    
    func loginCallCompletion(){
        
        let batchService = BatchService.init()
        batchService.createBatchWithHightestPrimaryKey()
        EZLoadingActivity.hide(true, animated: true)
        self.pushViewController()
        
    }
    
    func getAndPersistCookie(completion: @escaping () -> Void){

        let helper = MainVCHelper()
        helper.getCookie(){ dictionary,error in
            if dictionary != nil{
                self.connected = true
                helper.persistCookie(dictionary: dictionary)
            }
            completion()}

    }
    
    func pushViewController(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "captureImageView") as! CaptureImageViewController
        vc.connected = self.connected
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
