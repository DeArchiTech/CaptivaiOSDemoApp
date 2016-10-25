//
//  BatchServiceSpec.swift
//  SDKSampleApp
//
//  Created by davix on 10/24/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import Quick
import Nimble
import RealmSwift
@testable import SDKSampleApp

class BatchServiceSpec: QuickSpec {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    override func spec() {
        describe("#saveBatch"){
            it("writes the batch object to db"){
                let batchNum = "99"
                let batch = BatchObj()
                batch.batchNumber = batchNum
                
                let service = BatchService()
                service.deleteAllBatches()
                service.saveBatch(batch: batch)
                
                let result = service.loadNewestBatch()
                expect(result?.batchNumber).to(equal(batchNum))
            }
        }
        describe("#loadNewestBatch"){
            it("returns nil if there is nothing in the database"){
                let service = BatchService()
                service.deleteAllBatches()
                let result = service.loadNewestBatch()
                expect(result).to(beNil())
            }
            it("returns the batch with the newest creation date"){
                let service = BatchService()
                service.deleteAllBatches()
                
                let batchOneNumber = "batchNumOne"
                let batchTwoNumber = "batchNumTwo"
                
                let batchOne = BatchObj()
                batchOne.batchNumber = batchOneNumber
                
                let batchTwo = BatchObj()
                batchTwo.batchNumber = batchTwoNumber
                
                service.saveBatch(batch: batchOne)
                service.saveBatch(batch: batchTwo)
                
                let result = service.loadNewestBatch()
                expect(result?.batchNumber).to(equal(batchOneNumber))
                
            }
        }
        describe("#getBatchWithBatchNum"){
            it("returns nil if the batch can not be found"){
                let service = BatchService()
                service.deleteAllBatches()
                
                let result = service.getBatchWithBatchNum(num: "batchNum")
                expect(result).to(beNil())
            }
            it("returns the Batch with the Batch num"){
                let service = BatchService()
                service.deleteAllBatches()
                
                let batchOneNumber = "batchNumOne"
                let batchTwoNumber = "batchNumTwo"
                
                let batchOne = BatchObj()
                batchOne.batchNumber = batchOneNumber
                
                let batchTwo = BatchObj()
                batchTwo.batchNumber = batchTwoNumber
                
                service.saveBatch(batch: batchOne)
                service.saveBatch(batch: batchTwo)
                
                let result = service.getBatchWithBatchNum(num: batchOneNumber)
                expect(result?.batchNumber).to(equal(batchOneNumber))
            }
        }
        describe("#updateBatch"){
            it("it updates the batch given a batchNum"){
                let service = BatchService()
                service.deleteAllBatches()
                
                let batchNumber = "batchNum"
                let batch = BatchObj()
                batch.batchNumber = batchNumber
                service.saveBatch(batch: batch)
                
                let firstLoadResult = service.getBatchWithBatchNum(num: batchNumber)
                expect(firstLoadResult?.uploaded).to(equal(false))
                
                batch.uploaded = true
                let updateResult = service.updateBatchWithNum(batch: batch)
                
                expect(updateResult).to(equal(true))
                let secondLoadResult = service.getBatchWithBatchNum(num: batchNumber)
                expect(secondLoadResult?.uploaded).to(equal(true))
            }
        }
    }
    
}
