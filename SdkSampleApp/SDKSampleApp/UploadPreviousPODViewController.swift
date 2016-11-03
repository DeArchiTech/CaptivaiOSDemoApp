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
    
    class func newInstance() -> UploadPreviousPODViewController{
        return UploadPreviousPODViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
