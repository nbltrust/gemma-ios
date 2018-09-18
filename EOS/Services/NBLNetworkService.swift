//
//  NBLNetworkService.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import Moya
import SwifterSwift
import SwiftyJSON
import Alamofire
import HandyJSON

struct WookongValidation: HandyJSON {
    var SN: String!
    var SN_sig: String!
    var public_key: String!
    var public_key_sig: String!
}

enum CreateAPPId: Int {
    case gemma = 1
    case wookongSolo
    case wookong
    case bluetooth
}

enum NBLService {
    case createAccount(type: CreateAPPId, account:String, pubKey:String, invitationCode:String, validation:WookongValidation?)
    case accountVerify(account:String)
    case accountHistory(account:String, showNum:Int, lastPosition:Int)
    case producer(showNum:Int)
}

func defaultManager() -> Alamofire.SessionManager {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 5
    
    let manager = Alamofire.SessionManager(configuration: configuration)
    manager.startRequestsImmediately = false
    return manager
}

struct NBLNetwork {
    static let provider = MoyaProvider<NBLService>(callbackQueue: nil, manager: defaultManager(), plugins: [NetworkLoggerPlugin(verbose: true),DataCachePlugin()], trackInflights: false)
    
    static func request(
        target: NBLService,
        success successCallback: @escaping (JSON) -> Void,
        error errorCallback: @escaping (_ statusCode: Int) -> Void,
        failure failureCallback: @escaping (MoyaError) -> Void
        ) {
        
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                do {
                    let response = try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    if json["code"].intValue == 0 {
                        let result = json["result"]
                        successCallback(result)
                    }
                    else {
                        errorCallback(json["code"].intValue)
                    }
                }
                catch _ {
                    errorCallback(99999)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
    }

}


extension NBLService : TargetType {
    var baseURL: URL {
        return NetworkConfiguration.NBL_BASE_URL
    }
    
    var isNeedCache: Bool {
        switch self {
        case .producer(_):
            return true
        default:
            return false
        }
    }
    
    var path: String {
        switch self {
        case .createAccount(_, _, _, _, _):
            return "/api/v1/account/new"
        case let .accountVerify(account):
            return "/api/v1/account/\(account)/verify"
        case let .accountHistory(account, showNum, lastPosition):
            return "/api/v1/account/history/\(account)/\(lastPosition)/\(showNum)"
        case let .producer(showNum):
            return "/api/v1/producer/\(showNum)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createAccount(_, _, _, _, _):
            return .post
        case .accountVerify(_):
            return .get
        case .accountHistory:
            return .get
        case .producer(_):
            return .get
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .createAccount(type ,account, pubKey, invitationCode, validation):
            var map: [String: Any] =  ["account_name": account, "invitation_code": invitationCode, "public_key": pubKey, "app_id": type]
            if let val = validation {
                map["validation"] = val.toJSON()
            }
            return map
        case .accountVerify:
            return [:]
        case .accountHistory:
            return [:]
        case .producer:
            return [:]
        }
    }
    
    var task: Task {
        switch self {
        case .createAccount:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .accountVerify:
            return .requestPlain
        case .accountHistory:
            return .requestPlain
        case .producer:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return try! JSON(parameters).rawData()
    }

    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
