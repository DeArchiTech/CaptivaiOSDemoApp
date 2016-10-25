//
//  BatchService.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class BatchService{
    
    func saveBatch(batch : BatchObj) -> Bool{
        
        do{
            let realm = try Realm()
            try! realm.write {
                realm.add(batch)
            }
        } catch let error as NSError {
            return false
            print(error)
        }
        return true
        
    }
    
    func loadNewestBatch() -> BatchObj?{
        
        let objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj).sorted(byProperty: "createdAt")
        }()
        if objs.count > 0 {
            return objs.first
        }else{
            return nil
        }
        
    }
    
    func deleteAllBatches() -> Bool {
        
        var objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj)
        }()
        if objs.count > 0 {
            do{
                let realm = try Realm()
                for batch in objs{
                    try! realm.write {
                        realm.delete(batch)
                    }
                }
            } catch let error as NSError {
                return false
                print(error)
            }
        }
        objs = {
            try! Realm().objects(BatchObj)
        }()
        return objs.count == 0
        
    }
    
    func getBatchWithBatchNum(num : String) -> BatchObj?{
        
        let predicate = NSPredicate(format: "batchNumber == %@", NSString(string: num))
        let objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj.self).filter(predicate)
        }()
        if objs.count > 0 {
            return objs.first!
        }else{
            return nil
        }
        
    }
    
    func updateBatchWithNum(batch :BatchObj) -> Bool{
        
        //Updates the uploaded field
        let num = batch.batchNumber
        let predicate = NSPredicate(format: "batchNumber == %@", NSString(string: num))
        let objs: Results<BatchObj> = {
            try! Realm().objects(BatchObj.self).filter(predicate)
        }()
        if objs.count > 0 {
            let updateObj = objs.first!
            do{
                let realm = try Realm()
                let value = batch.uploaded
                try! realm.write {
                    updateObj.uploaded = value
                }
                return true
            }catch let error as NSError {
                print(error)
                return false
            }
        }else{
            return false
        }
    }
    
}
