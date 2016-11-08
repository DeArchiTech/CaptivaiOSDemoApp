//
//  ErrorUtil.swift
//  SDKSampleApp
//
//  Created by davix on 11/7/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation

class ErrorUtil{

    static func throwError(message: String) throws {
        throw MyError.RuntimeError(message)
    }
    
}

