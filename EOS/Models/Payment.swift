//
//  payment.swift
//  EOS
//
//  Created by koofrank on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import HandyJSON

struct Payment:HandyJSON {
    var from:String!
    var to:String!
    var value:String! //1.0000 EOS
    var memo:String!
    var time:Date!
    var block:String!
    var hash:String!
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            time <-- DateTransform()
    }
    
    init() {}
}
