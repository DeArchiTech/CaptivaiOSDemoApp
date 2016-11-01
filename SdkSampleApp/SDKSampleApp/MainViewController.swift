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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = UIActivityIndicatorView.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func scanNewPodButtonClicked(_ sender: Any) {
        
        let service = LoginService.init()
        service.login(){ (dictionary,error) -> () in
            let batchService = BatchService.init()
            batchService.createBatchWithHightestPrimaryKey()
            EZLoadingActivity.hide(true, animated: true)
            self.pushViewController()
        }
        EZLoadingActivity.show("Connecting to server...", disableUI: true)
        
    }
    
    func pushViewController(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "captureImageView") as! CaptureImageViewController
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
