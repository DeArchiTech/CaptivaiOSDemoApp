//
//  CreateProfileService.swift
//  SDKSampleApp
//
//  Created by davix on 10/5/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CreateProfileService{
    
    func saveProfile(profile :FilterProfile) -> Bool{
        
        do{
            let realm = try Realm()
            try! realm.write {
                realm.add(profile)
            }
        } catch let error as NSError {
            return false
            print(error)
        }
        return true
        
    }
    
    func loadProfiles() -> [FilterProfile]?{

        let objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile)
        }()
        var result : [FilterProfile] = []
        for profile in objs{
            result.append(profile)
        }
        return result
        
    }
    
    func deleteAllProfiles() -> Bool {
        
        var objs: Results<FilterProfile> = {
            try! Realm().objects(FilterProfile)
        }()
        if objs.count > 0 {
            do{
                let realm = try Realm()
                for profile in objs{
                    try! realm.write {
                        realm.delete(profile)
                    }
                }
            } catch let error as NSError {
                return false
                print(error)
            }
        }
        objs = {
            try! Realm().objects(FilterProfile)
        }()
        return objs.count == 0
        
    }
    
    func containsProfileName(name: String) -> Bool {
        
        let profiles = self.loadProfiles()
        var result = false
        if profiles != nil {
            for profile in profiles! {
                if profile.profileName == name{
                    result = true
                    break
                }
            }
        }
        return result
    }
}
