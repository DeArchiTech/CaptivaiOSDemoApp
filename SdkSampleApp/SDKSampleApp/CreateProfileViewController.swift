//
//  CreateProfileViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/6/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import UIKit
import Foundation

@objc class CreateProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    class func newInstance() -> CreateProfileViewController{
        return CreateProfileViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getFilterList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = getFilterList()[indexPath.item]
        return cell
    }
    
    func getFilterList() -> [String]{
        return ["Black-White","Gray","Deskew","Auto Crop","Resize","Rotate 180",
        "Rotate Left","Rotate Right","Crop","Lighter","Darker","Increase Contrast",
        "Remove Noise","Get Information","Export to Photos","Quadrilateral Crop",
        "Detect barcodes"]
    }
    
}
