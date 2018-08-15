//
//  RPCTest.swift
//  EOSTests
//
//  Created by koofrank on 2018/8/10.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import XCTest
import Nimble
import HandyJSON
import SwiftDate
import SwiftyJSON
import SwiftyBeaver

@testable import EOS

class RPCTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAccountValid() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var result = false
        
        WalletManager.shared.validChainAccountCreated("test1") { (success) in
            if success {
                result = true
            }
        }
        
        expect(result).toEventually(beTrue(), timeout: 3)
    }
    
    func testGetRamPrice() {
        var result = Decimal(floatLiteral: 0)

        getRamPrice { (price) in
            if let price = price as? Decimal {
                result = price
            }
        }
       
        expect(result.doubleValue).toEventually(beGreaterThan(0), timeout: 3)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testVote() {
        var result = false
        let producer = TableProducers()
        if let str = producer.toJSONString() {
            EOSIONetwork.request(target: .get_producers(json: str), success: {[weak self] (json) in
//                log.debug(json)
                let voteData = NodeVoteData.deserialize(from: json.dictionaryObject)
                log.debug(voteData)
                result = true
                }
                , error: { (code) in
                    
            }, failure: { (error) in
                
            })
        }
        
        expect(result).toEventually(beTrue(), timeout: 3)
    }
}
