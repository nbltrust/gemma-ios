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

enum NBLService {
    case createAccount(account:String, pubKey:String, invitationCode:String)
}

struct NBLNetwork {
    static let provider = MoyaProvider<NBLService>(callbackQueue: nil, manager: MoyaProvider<NBLService>.defaultAlamofireManager(), plugins: [NetworkLoggerPlugin(verbose: true)], trackInflights: false)
    
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


extension NBLService : TargetType {
    var baseURL: URL {
        return NetworkConfiguration.NBL_BASE_URL
    }
    
    var path: String {
        switch self {
        case .createAccount(_, _, _):
            return "/api/v1/faucet/new"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        switch self {
        case let .createAccount(account, pubKey, invitationCode):
            return "{\"account_name\": \(account), \"invitation_code\": \(invitationCode), \"public_key\": \(pubKey)}".utf8Encoded
        }
    }
    
    var task: Task {
        return .requestPlain
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
