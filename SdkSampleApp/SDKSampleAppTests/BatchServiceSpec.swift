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
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    override func spec() {
        describe("#saveBatch"){
            it("writes the batch object to db"){
                let batchNum = 99
                let batch = BatchObj()
                batch.batchNumber = batchNum
                
                let service = BatchService()
                expect(service.deleteAllBatches()).to(beTruthy())
                expect(service.saveBatch(batch: batch)).to(beTruthy())
                
                let result = service.loadNewestBatch()
                expect(result?.batchNumber).to(equal(batchNum))
            }
        }
        describe("#loadNewestBatch"){
            it("returns nil if there is nothing in the database"){
                let service = BatchService()
                expect(service.deleteAllBatches()).to(beTruthy())
                let result = service.loadNewestBatch()
                expect(result).to(beNil())
            }
            it("returns the batch with the newest creation date"){
                let service = BatchService()
                expect(service.deleteAllBatches()).to(beTruthy())
                
                let batchOneNumber = 11
                let batchTwoNumber = 22
                
                let batchOne = BatchObj()
                batchOne.batchNumber = batchOneNumber
                
                let batchTwo = BatchObj()
                batchTwo.batchNumber = batchTwoNumber
                
                expect(service.saveBatch(batch: batchOne)).to(beTruthy())
                expect(service.saveBatch(batch: batchTwo)).to(beTruthy())
                
                let result = service.loadNewestBatch()
                expect(result?.batchNumber).to(equal(batchOneNumber))
                
            }
        }
        describe("#getBatchWithBatchNum"){
            it("returns nil if the batch can not be found"){
                let service = BatchService()
                expect(service.deleteAllBatches()).to(beTruthy())
                
                let result = service.getBatchWithBatchNum(num: 234)
                expect(result).to(beNil())
            }
            it("returns the Batch with the Batch num"){
                let service = BatchService()
                service.deleteAllBatches()
                
                let batchOneNumber = 111
                let batchTwoNumber = 222
                
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
                
                let batchNumber = 123
                let batch = BatchObj()
                batch.batchNumber = batchNumber
                service.saveBatch(batch: batch)
                
                let firstLoadResult = service.getBatchWithBatchNum(num: batchNumber)
                expect(firstLoadResult?.uploaded).to(equal(false))
                
                batch.uploaded = true
                let updateResult = service.updateBatchUpdatedToTrue(num: batchNumber)
                
                expect(updateResult).to(equal(true))
                let secondLoadResult = service.getBatchWithBatchNum(num: batchNumber)
                expect(secondLoadResult?.uploaded).to(equal(true))
            }
        }
        describe("#currentBatchNumber"){
            it("returns zero if there is not any batch in the database"){
                let service = BatchService()
                service.deleteAllBatches()
                let result = service.getCurrentBatchNum()
                expect(result).to(equal(0))
            }
            it("returns the batch number that is highest and also not uploaded"){
                let service = BatchService()
                service.deleteAllBatches()
                let obj1 = BatchObj()
                let obj2 = BatchObj()
                let obj3 = BatchObj()
                let expected = 3
                
                obj1.uploaded = true
                obj1.batchNumber = 1
                obj2.uploaded = false
                obj2.batchNumber = 2
                obj3.uploaded = true
                obj3.batchNumber = expected
                
                service.saveBatch(batch : obj1)
                service.saveBatch(batch : obj2)
                service.saveBatch(batch : obj3)
                
                let result = service.getCurrentBatchNum()
                expect(result).to(equal(expected))
                
            }
        }
    }
    
}
