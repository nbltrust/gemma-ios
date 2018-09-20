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

protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

class DataCachePlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePolicyGettable = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }
        return request
    }
}

final class EOSDataCachePlugin: DataCachePlugin {
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard case Result.success(_) = result else { return }
        
        if let service = target as? EOSIOService {
            if service.isNeedCache {
                do {
                    if let response = result.value {
                        _ = try response.filterSuccessfulStatusCodes()
                        let json = try JSON(response.mapJSON())
                    }
                }
                catch _ {}
            }
        }
    }
}

final class NBLDataCachePlugin: DataCachePlugin {
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard case Result.success(_) = result else { return }
        if let service = target as? NBLService {
            if service.isNeedCache {
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
    }
}

extension NBLService: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .producer(_):
            return .useProtocolCachePolicy
        default:
            return .reloadIgnoringLocalCacheData
        }
    }
}

extension EOSIOService: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .get_account(_,_):
            return .useProtocolCachePolicy
        default:
            return .reloadIgnoringLocalCacheData
        }
    }
}
