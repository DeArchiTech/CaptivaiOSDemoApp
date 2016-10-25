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

@objc class CaptivaLocalImageService: NSObject{
    
    class func newInsatnce() -> CaptivaLocalImageService{
        return CaptivaLocalImageService()
    }
    
    func saveImage(image: CaptivaLocalImageObj) -> Bool{
        
        do{
            let realm = try Realm()
            let path = image.imagePath
            let num = image.batchNumber
            try! realm.write {
                realm.add(image)
            }
        } catch let error as NSError {
            return false
            print(error)
        }
        return true
        
    }
    
    func loadImagesFromBatchNumber(batchNumber: Int) -> [CaptivaLocalImageObj]?{
        
        let predicate = NSPredicate(format: "batchNumber == %d", batchNumber)
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
    
    func deleteAllImages() -> Bool {
        
        var objs: Results<CaptivaLocalImageObj> = {
            try! Realm().objects(CaptivaLocalImageObj)
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
            try! Realm().objects(CaptivaLocalImageObj)
        }()
        return objs.count == 0
        
    }

}
