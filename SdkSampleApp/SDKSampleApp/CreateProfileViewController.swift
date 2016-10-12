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
    
    func removeFilterFromList(filter: String) -> Bool {
        
        let originalCount = self.filterSelected.count
        let index = self.filterSelected.index(of: filter)!
        self.filterSelected.remove(at: index)
        return (self.filterSelected.count == (originalCount - 1))
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = tableView.cellForRow(at: indexPath)
        let selectedItem = cell?.textLabel?.text!
        //Todo
        let selected = (cell?.accessoryType == UITableViewCellAccessoryType.checkmark)
        if selected{
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            self.addFilterToList(filter: selectedItem!)
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.none
            self.removeFilterFromList(filter: selectedItem!)
        }
        
    }
    
    func createFilterProfile() -> FilterProfile?{
        
        let profile = FilterProfile.init()
        for filter in filterSelected {
            let object = FilterObject.init()
            object.filterName = filter
            profile.filters.append(object)
        }
        return profile
        
    }
    
    @IBAction func buttonClicked(_ sender: AnyObject) {
        
        let profile = self.createFilterProfile()
        profile?.profileName = self.profileName.text!
        let service = CreateProfileService()
        if service.containsProfileName(name: self.profileName.text!){
            self.displayDuplicateNameAlert()
        }else{
            let result = service.saveProfile(profile: profile!)
            self.displayCreateProfileResult(result: result)
        }
        
    }
    
    func displayDuplicateNameAlert(){
        
        let alertController = UIAlertController(title: "Create Profile Action Failed", message:
            "Duplicate Name In Database", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func displayCreateProfileResult(result: Bool){
        
        var resultString = ""
        if (result) {
            resultString = "Success"
        }else {
            resultString = "Failed"
        }
        let alertController = UIAlertController(title: "Create Profile Action", message:
            resultString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
