//
//  SelectProfileViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/12/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import UIKit
import Foundation

@objc class SelectProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    var previousSelectedInex = -1
    
    class func newInstance() -> SelectProfileViewController{
        return SelectProfileViewController()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Taping anywhere closes keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //Assign tableview delegate/ datasource to self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getProfileNames().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = getProfileNames()[indexPath.item]
        return cell
        
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = tableView.cellForRow(at: indexPath)
        let selectedItem = cell?.textLabel?.text!
        //Todo
        let selected = (cell?.accessoryType == UITableViewCellAccessoryType.checkmark)
        if selected{
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        self.saveSelectedProfile(name: selectedItem!)
        
    }
    
    func getProfileNames() -> [String]{
        
        return ["A", "B", "C", "D", "E"]
        
    }
    
    func saveSelectedProfile(name : String) -> Bool{
    
        //1)Call Service to update all selected to false
        let service = CreateProfileService()
        service.updateAllSelectedToFalse()
//        service.updateProfileSelectedToTrue(name)
        return false
    
    }

}
