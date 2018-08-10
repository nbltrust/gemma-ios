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
        let json = TableProducers().toJSONString()
        print(json)
        
        EOSIONetwork.request(target: .get_account(account: "test1"), success: { (account) in
            let created = account["created"].stringValue.toISODate()!
            
            EOSIONetwork.request(target: .get_info, success: { (info) in
                let lib = info["last_irreversible_block_num"].stringValue
                EOSIONetwork.request(target: .get_block(num: lib), success: { (block) in
                    let time = block["timestamp"].stringValue.toISODate()!
                    if  time >= created {
                        result = true
                    }
                    
                }, error: { (code2) in
                    
                }, failure: { (error2) in
                    
                })
            }, error: { (code3) in
                
            }, failure: { (error3) in
                
            })
        }, error: { (code) in
            
        }, failure: { (error) in
            
        })
        
        expect(result).toEventually(beTrue(), timeout: 3)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
