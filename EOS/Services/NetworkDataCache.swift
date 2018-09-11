//
//  NetworkDataCache.swift
//  EOS
//
//  Created by peng zhu on 2018/9/10.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import enum Result.Result
import SwiftyJSON

class DataCachePlugin: PluginType {
    private let needCache: Bool = false
    
    init(needCache: Bool) {
        self.needCache = needCache
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard case Result.success(_) = result else { return }
    }
}

final class EOSDataCachePlugin: DataCachePlugin {
    override func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        do {
            if let response = result.value {
                _ = try response.filterSuccessfulStatusCodes()
                let json = try JSON(response.mapJSON())
                
            }
        }
        catch _ {}
    }
}

final class NBLDataCachePlugin: DataCachePlugin {
    override func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        do {
            if let response = result.value {
                let response = try response.filterSuccessfulStatusCodes()
                let json = try JSON(response.mapJSON())
                if json["code"].intValue == 0 {
                    let result = json["result"]
                    
                }
                
            }
        }
        catch _ {}
    }
}
