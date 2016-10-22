//
//  UploadImageViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/21/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import UIKit
import Foundation

@objc class UploadImageViewController: UIViewController{
    
    var previousSelectedInex = -1
    var profileNames : [String] = []
    
    class func newInstance() -> UploadImageViewController{
        return UploadImageViewController()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Taping anywhere closes keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = UIColor.blue
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
}
