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
import SwiftyUserDefaults

enum EOSIOService {
    //chain
    case getCurrencyBalance(account: String)
    case getAccount(account: String, otherNode: Bool)
    case getInfo
    case getBlock(num: String)
    case abiJsonToBin(json: String)
    case abiBinToJson(bin: String, action:EOSAction)
    case pushTransaction(json: String)
    case getTableRows(json:String)

    //history
    case getKeyAccounts(pubKey: String)
    case getTransaction(id: String)
}

struct EOSIONetwork {
    static let provider = MoyaProvider<EOSIOService>(callbackQueue: nil,
                                                     manager: MoyaProvider<EOSIOService>.defaultAlamofireManager(),
                                                     plugins: [NetworkLoggerPlugin(verbose: true), DataCachePlugin()],
                                                     trackInflights: false)

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
                    switch target {
                    case let .getCurrencyBalance(accountName):
                        if let balance = json.arrayValue.first?.string {
                            Defaults.set(balance, forKey: "\(accountName)balance")
                        }
                    case .getAccount:
                        if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                            var model = accountObj.toAccountModel()
                            model.saveToLocal()
                        }
                    case .getInfo:break

                    case .getBlock:break

                    case .abiJsonToBin:break

                    case .abiBinToJson:break

                    case .pushTransaction:break

                    case .getKeyAccounts:break

                    case .getTransaction:break

                    case .getTableRows:break

                    }

                    successCallback(json)
                } catch _ {
                    do {
                        let json = try JSON(response.mapJSON())
                        let error = json["error"]["code"].debugDescription
                        let codeKey = AppConfiguration.EOSErrorCodeBase + error
                        let codeValue = codeKey.localized()
                        showFailTop(codeValue)
                    } catch _ {

                    }
                    errorCallback(0)
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

extension EOSIOService: TargetType {
    var baseURL: URL {
        let configuration = NetworkConfiguration()
        switch self {
        case .getAccount:
//            if otherNode {
//                return  configuration.EOSIO_OTHER_BASE_URL
//            }
            return configuration.EOSIOBaseURL
        default:
            return configuration.EOSIOBaseURL
        }
    }

    var isNeedCache: Bool {
        switch self {
        case .getAccount:
            return true
        default:
            return false
        }
    }

    var path: String {
        switch self {
        case .getCurrencyBalance:
            return "/v1/chain/get_currency_balance"
        case .getAccount:
            return "/v1/chain/get_account"
        case .getInfo:
            return "/v1/chain/get_info"
        case .getBlock:
            return "/v1/chain/get_block"
        case .abiJsonToBin:
            return "/v1/chain/abi_json_to_bin"
        case .abiBinToJson:
            return "/v1/chain/abi_bin_to_json"
        case .pushTransaction:
            return "/v1/chain/push_transaction"
        case .getKeyAccounts:
            return "/v1/history/get_key_accounts"
        case .getTransaction:
            return "/v1/history/get_transaction"
        case .getTableRows:
            return "/v1/chain/get_table_rows"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case let .getCurrencyBalance(account):
            return ["account": account, "code": EOSIOContract.TokenCode, "symbol": NetworkConfiguration.EOSIODefaultSymbol]
        case let .getAccount(account, _):
            return ["account_name": account]
        case .getInfo:
            return [:]
        case let .getBlock(num):
            return ["block_num_or_id": num]
        case let .abiJsonToBin(json):
            return JSON(parseJSON: json).dictionaryObject ?? [:]
        case let .pushTransaction(json):
            var transaction: [String: Any] = ["compression": "none"]
            var jsonOb = JSON(parseJSON: json).dictionaryObject ?? [:]
            let signatures = jsonOb["signatures"]
            jsonOb.removeValue(forKey: "signatures")
            transaction["signatures"] = signatures
            transaction["transaction"] = jsonOb

            return transaction
        case let .abiBinToJson(bin, action):
            return ["code": EOSIOContract.TokenCode, "action": action.rawValue, "binargs": bin]
        case let .getKeyAccounts(pubKey):
            return ["public_key": pubKey]
        case let .getTransaction(id):
            return ["id": id]
        case let .getTableRows(json):
            return JSON(parseJSON: json).dictionaryObject ?? [:]
        }
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }

    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        guard let data = try? JSON(parameters).rawData() else {
            return Data()
        }
        return data
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
