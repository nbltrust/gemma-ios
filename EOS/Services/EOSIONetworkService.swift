//
//  EOSIONetworkService.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import Moya
import SwifterSwift
import SwiftyJSON

enum EOSIOService {
    //chain
    case get_currency_balance(account: String)
    case get_account(account: String)
    case get_info
    case get_block(num: String)
    case abi_json_to_bin(json: String)
    case abi_bin_to_json(bin: String, action:EOSAction)
    case push_transaction(json: String)
    
    //history
    case get_key_accounts(pubKey:String)
}

struct EOSIONetwork {
    static let provider = MoyaProvider<EOSIOService>(callbackQueue: nil, manager: MoyaProvider<EOSIOService>.defaultAlamofireManager(), plugins: [NetworkLoggerPlugin(verbose: true)], trackInflights: false)
    
    static func request(
        target: EOSIOService,
        success successCallback: @escaping (JSON) -> Void,
        error errorCallback: @escaping (_ statusCode: Int) -> Void,
        failure failureCallback: @escaping (MoyaError) -> Void
        ) {
        
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    successCallback(json)
                }
                catch _ {
                    errorCallback(0)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
    }
    
}


extension EOSIOService : TargetType {
    var baseURL: URL {
        return NetworkConfiguration.EOSIO_BASE_TEST_URL
    }
    
    var path: String {
        switch self {
        case .get_currency_balance(_):
            return "/v1/chain/get_currency_balance"
        case .get_account(_):
            return "/v1/chain/get_account"
        case .get_info:
            return "/v1/chain/get_info"
        case .get_block:
            return "/v1/chain/get_block"
        case .abi_json_to_bin:
            return "/v1/chain/abi_json_to_bin"
        case .abi_bin_to_json:
            return "/v1/chain/abi_bin_to_json"
        case .push_transaction:
            return "/v1/chain/push_transaction"
        case .get_key_accounts:
            return "/v1/history/get_key_accounts"
        }
    }
    
    
    var parameters: [String: Any] {
        switch self {
        case let .get_currency_balance(account):
            return ["account": account, "code": NetworkConfiguration.EOSIO_DEFAULT_CODE, "symbol": NetworkConfiguration.EOSIO_DEFAULT_SYMBOL]
        case let .get_account(account):
            return ["account_name": account]
        case .get_info:
            return [:]
        case let .get_block(num):
            return ["block_num_or_id": num]
        case let .abi_json_to_bin(json):
            return JSON(parseJSON: json).dictionaryObject ?? [:]
        case let .push_transaction(json):
            var transaction:[String: Any] = ["compression":"none"]
            var jsonOb = JSON(parseJSON: json).dictionaryObject ?? [:]
            let signatures = jsonOb["signatures"]
            jsonOb.removeValue(forKey: "signatures")
            transaction["signatures"] = signatures
            transaction["transaction"] = jsonOb
            
            return transaction
        case let .abi_bin_to_json(bin, action):
            return ["code": NetworkConfiguration.EOSIO_DEFAULT_CODE, "action": action.rawValue, "binargs": bin]
        case let .get_key_accounts(pubKey):
            return ["public_key": pubKey]
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }

    var method: Moya.Method {
        return .post
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
