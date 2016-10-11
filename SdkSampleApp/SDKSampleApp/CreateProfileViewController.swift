//
//  CreateProfileViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/6/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import UIKit
import Foundation

@objc class CreateProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    @IBOutlet var createProfileButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var profileName: UITextField!
    
    var filterSelected : [String] = []
    
    class func newInstance() -> CreateProfileViewController{
        return CreateProfileViewController()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Taping anywhere closes keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        profileName.delegate = self
        
        //Assign tableview delegate/ datasource to self
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func addFilterToList(filter: String) -> Bool {
        
        self.filterSelected.append(filter)
        return self.filterSelected.count > 0
        
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        let selectedItem = cell?.textLabel?.text!
        self.addFilterToList(filter: selectedItem!)
    }
    
    @IBAction func buttonClicked(_ sender: AnyObject) {
        
        //Persist filter profile object into Database
    
    }
    
}
