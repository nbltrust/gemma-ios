//
//  EOSTests.swift
//  EOSTests
//
//  Created by koofrank on 2018/8/8.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import EOS

class EOSTests: QuickSpec {
    override func spec() {
        describe("import key and guarantee account be confirmed") {
            it("should be true") {
                var result = false
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
            
//            context("if it doesn't have what you're looking for") {
//                it("needs to be updated") {
//
//                }
//            }
        }
    }
}
