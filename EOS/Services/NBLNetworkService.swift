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
    var SN = ""
    var SN_sig = ""
    var public_key = ""
    var public_key_sig = ""
    var publicKey = ""
}

enum CreateAPPId: Int, Codable {
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
    case initOrder(account:String, pubKey:String, platform:String, client_ip: String, serial_number:String)
    case getBill
    case place(orderId: String)
    case getOrder(orderId: String)
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
    static let provider = MoyaProvider<NBLService>(callbackQueue: nil, manager: defaultManager(), plugins: [NetworkLoggerPlugin(verbose: true), DataCachePlugin()], trackInflights: false)

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
                    } else {
                        errorCallback(json["code"].intValue)
                    }
                } catch _ {
                    errorCallback(99999)
                }
            case let .failure(error):
                let networkStr = getNetWorkReachability()
                if networkStr != WifiStatus.notReachable.rawValue {
                    showFailTop(R.string.localizable.request_failed.key.localized())
                } else {
                    endProgress()
                }
                failureCallback(error)
            }
        }
    }

}

extension NBLService: TargetType {
    var baseURL: URL {
        return NetworkConfiguration.NBL_BASE_TEST_URL
    }

    var isNeedCache: Bool {
        switch self {
        case .producer:
            return true
        default:
            return false
        }
    }

    var path: String {
        switch self {
        case .createAccount:
            return "/api/v1/account/new"
        case let .accountVerify(account):
            return "/api/v1/account/verify/\(account)"
        case let .accountHistory(account, showNum, lastPosition):
            return "/api/v1/account/history/\(account)/\(lastPosition)/\(showNum)"
        case let .producer(showNum):
            return "/api/v1/producer/\(showNum)"
        case .initOrder:
            return "/api/v1/pay/order"
        case .getBill:
            return "/api/v1/pay/bill"
        case let .place(orderId):
            return "/api/v1/pay/order/\(orderId)/place"
        case let .getOrder(orderId):
            return "/api/v1/pay/order/\(orderId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createAccount:
            return .post
        case .accountVerify:
            return .post
        case .accountHistory:
            return .get
        case .producer:
            return .get
        case .initOrder:
            return .post
        case .getBill:
            return .get
        case .place:
            return .post
        case .getOrder:
            return .get
        }
    }

    var parameters: [String: Any] {
        switch self {
        case let .createAccount(type, account, pubKey, invitationCode, validation):
            var map: [String: Any] =  ["account_name": account, "invitation_code": invitationCode, "public_key": pubKey, "app_id": type.rawValue]
            if let val = validation {
                var valDic = val.toJSON()
                map["public_key"] = valDic?["publicKey"]
                valDic?.removeValue(forKey: "publicKey")
                map.removeValue(forKey: "invitation_code")
                map["validation"] = valDic
            }
            return map
        case .accountVerify:
            return [:]
        case .accountHistory:
            return [:]
        case .producer:
            return [:]
        case let .initOrder(account, pubKey, platform, client_ip, serial_number):
            return ["account_name": account, "public_key": pubKey, "platform": platform, "client_ip": client_ip, "serial_number": serial_number]
        case .getBill:
            return [:]
        case .place:
            return [:]
        case .getOrder:
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
        case .initOrder:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getBill:
            return .requestPlain
        case .place:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getOrder:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return try! JSON(parameters).rawData()
    }

    var headers: [String: String]? {
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
