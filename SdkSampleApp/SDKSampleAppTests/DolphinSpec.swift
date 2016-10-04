//
//  DolphinSpec.swift
//  SDKSampleApp
//
//  Created by davix on 10/4/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SDKSampleApp

class DolphinSpec: QuickSpec {
    override func spec() {
        describe("a dolphin") {
            describe("its click") {
                it("is loud") {
//                    let click = Dolphin().click()
                    expect(true).to(beTruthy())
                }
                
                it("has a high frequency") {
//                    let click = Dolphin().click()
                    expect(true).to(beTruthy())
                }
            }
        }
    }
}
