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
    
    func getImage() {
        
    }
    
    func createJson() {
        
    }
    
    func uploadImage() {
        
    }
    
}
