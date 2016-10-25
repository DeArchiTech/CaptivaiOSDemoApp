//
//  CaptivaLocalImageService.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CaptivaLocalImageService{
    
    func saveImage(image: CaptivaLocalImageObj) -> Bool{
        
        do{
            let realm = try Realm()
            try! realm.write {
                realm.add(image)
            }
        } catch let error as NSError {
            return false
            print(error)
        }
        return true
        
    }
    
    func loadImagesFromBatchNumber(batchNumber: String) -> [CaptivaLocalImageObj]?{
        
        let predicate = NSPredicate(format: "batchNumber == %@", NSString(string: batchNumber))
        let objs: Results<CaptivaLocalImageObj> = {
            try! Realm().objects(CaptivaLocalImageObj.self).filter(predicate)
        }()
        if objs.count > 0 {
            var result : [CaptivaLocalImageObj] = []
            for imageObj in objs {
                result.append(imageObj)
            }
            return result
        }else{
            return nil
        }
        
    }
    
}
