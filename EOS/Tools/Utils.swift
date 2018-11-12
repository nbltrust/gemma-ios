//
//  Utils.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwifterSwift
import Device
import NotificationBanner
import NBLCommonModule
import KRProgressHUD
import SwiftyUserDefaults
import Alamofire
import SwiftyJSON
import eos_ios_core_cpp

//Coin Datas
func coinUnit() -> String {
    let data = CoinUnitConfiguration.values
    let coinIndex = Defaults[.coinUnit]
    return data[coinIndex]
}

func coinType() -> CoinType {
    let coinIndex = Defaults[.coinUnit]
    if let type = CoinType(rawValue: coinIndex) {
        return type
    }
    return .CNY
}

//func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = UIColor.white) {
//}
class ActionModel {
    var password: String = ""
    var fromAccount: String = ""
    var toAccount: String = ""
    var success: String = ""
    var faile: String = ""
}

class TransferActionModel: ActionModel {
    var amount: String = ""
    var remark: String = ""
    var type: CreateAPPId = .gemma
    var confirmType: AuthType = pinType
    var contract: String = ""
    var symbol: String = ""
}

class DelegateActionModel: ActionModel {

}

class UnDelegateActionModel: ActionModel {

}

class BuyRamActionModel: ActionModel {
    var amount: String = ""
}

class SellRamActionModel: ActionModel {
    var amount: String = ""
}

class VoteProducerActionModel: ActionModel {
    var producers: [String] = [String]()
}

func getAbi(_ action: String, actionModel: ActionModel) -> String! {
    var abi: String = ""

    switch action {
    case EOSAction.transfer.rawValue, EOSAction.bltTransfer.rawValue:
        if let actionModel = actionModel as? TransferActionModel {
            if let abiStr = EOSIO.getAbiJsonString(actionModel.contract,
                                                   action: EOSAction.transfer.rawValue,
                                                   from: actionModel.fromAccount,
                                                   to: actionModel.toAccount,
                                                   quantity: actionModel.amount + " " + actionModel.symbol,
                                                   memo: actionModel.remark) {
                abi = abiStr
            }
        }
    case EOSAction.buyram.rawValue:
        if let actionModel = actionModel as? BuyRamActionModel {
            if let abiStr = EOSIO.getBuyRamAbi(EOSIOContract.EOSIOCode,
                                               action: action,
                                               payer: CurrencyManager.shared.getCurrentAccountName(),
                                               receiver: CurrencyManager.shared.getCurrentAccountName(),
                                               quant: actionModel.amount + " " + NetworkConfiguration.EOSIODefaultSymbol) {
                abi = abiStr
            }
        }
    case EOSAction.sellram.rawValue:
        if let actionModel = actionModel as? SellRamActionModel {
            if let abiStr = EOSIO.getSellRamAbi(EOSIOContract.EOSIOCode, action: action, account: CurrencyManager.shared.getCurrentAccountName(), bytes: actionModel.amount.toBytes) {
                abi = abiStr
            }
        }
    case EOSAction.voteproducer.rawValue:
        guard let voteModel = actionModel as? VoteProducerActionModel else {
            return ""
        }
        let voter: [String: Any] = ["voter": CurrencyManager.shared.getCurrentAccountName(), "proxy": "", "producers": voteModel.producers]
        let dic: [String: Any] = ["code": EOSIOContract.EOSIOCode, "action": action, "args": voter]
        abi = dic.jsonString()!

    case EOSAction.delegatebw.rawValue, EOSAction.undelegatebw.rawValue:
        if (UIApplication.shared.delegate as? AppDelegate) != nil {
            if let vc = appCoodinator.newHomeCoordinator.rootVC.topViewController as? ResourceMortgageViewController {
                var cpuValue = ""
                var netValue = ""

                if action == EOSAction.delegatebw.rawValue {
                    if var cpu = vc.coordinator?.state.property.cpuMoneyValid.value.2 {
                        if cpu == "" {
                            cpu = "0.0000"
                        }
                        cpuValue = cpu + " \(NetworkConfiguration.EOSIODefaultSymbol)"
                    }
                    if var net = vc.coordinator?.state.property.netMoneyValid.value.2 {
                        if net == "" {
                            net = "0.0000"
                        }
                        netValue = net + " \(NetworkConfiguration.EOSIODefaultSymbol)"
                    }

                    if let abiStr = EOSIO.getDelegateAbi(EOSIOContract.EOSIOCode,
                                                         action: action,
                                                         from: actionModel.fromAccount,
                                                         receiver: actionModel.toAccount,
                                                         stake_net_quantity: netValue,
                                                         stake_cpu_quantity: cpuValue) {
                        abi = abiStr
                    }
                } else if action == EOSAction.undelegatebw.rawValue {
                    if var cpu = vc.coordinator?.state.property.cpuReliveMoneyValid.value.2 {
                        if cpu == "" {
                            cpu = "0.0000"
                        }
                        cpuValue = cpu + " \(NetworkConfiguration.EOSIODefaultSymbol)"
                    }
                    if var net = vc.coordinator?.state.property.netReliveMoneyValid.value.2 {
                        if net == "" {
                            net = "0.0000"
                        }
                        netValue = net + " \(NetworkConfiguration.EOSIODefaultSymbol)"
                    }

                    if let abiStr = EOSIO.getUnDelegateAbi(EOSIOContract.EOSIOCode,
                                                           action: action,
                                                           from: actionModel.fromAccount,
                                                           receiver: actionModel.toAccount,
                                                           unstake_net_quantity: netValue,
                                                           unstake_cpu_quantity: cpuValue) {
                        abi = abiStr
                    }
                }

            }
        }
    default:
        break

    }
  
    return abi
}

func transaction(_ action: String, actionModel: ActionModel, callback:@escaping (Bool, String) -> Void) {
    var abi = ""
    if let getabi = getAbi(action, actionModel: actionModel) {
        abi = getabi
    } else {
        callback(false, "")
        return
    }

    EOSIONetwork.request(target: .getInfo, success: { (json) in

        EOSIONetwork.request(target: .abiJsonToBin(json: abi), success: { (binJson) in
            var transaction = ""
            let abiStr = binJson["binargs"].stringValue

            var privakey = ""
            if let currency = CurrencyManager.shared.getCurrentCurrency(), let key = WalletManager.shared.getCachedPriKey(currency, password: actionModel.password)  {
                privakey = key
            }

            if action == EOSAction.transfer.rawValue, let actionModel = actionModel as? TransferActionModel {
                transaction = EOSIO.getTransferTransaction(privakey, code: actionModel.contract, from: actionModel.fromAccount, getinfo: json.rawString(), abistr: abiStr)
            } else if action == EOSAction.bltTransfer.rawValue, let actionModel = actionModel as? TransferActionModel {
                if let keys = EOSIO.createKey(), let pri = keys[optional: 1] {
                    privakey = pri
                }
                transaction = EOSIO.getTransferTransaction(privakey, code: actionModel.contract, from: actionModel.fromAccount, getinfo: json.rawString(), abistr: abiStr)
                let transJson = JSON.init(parseJSON: transaction)
                var transJsonMap = transJson.dictionaryObject
                if let actionModel = actionModel as? TransferActionModel {
                    var tempMap = transJsonMap
                    if let prewfixValue = tempMap?["ref_block_prefix"] {
                        tempMap?["ref_block_prefix"] = "\(prewfixValue)"
                    }
                    tempMap?.removeValue(forKey: "signatures")

                    let jsonDic = json.dictionaryObject

                    let chainId = jsonDic?["chain_id"] as? String ?? ""

                    let transString = tempMap?.sortJsonString() ?? ""

                    BLTWalletIO.shareInstance()?.getEOSSign(actionModel.confirmType, chainId: chainId, transaction: transString, success: { (sign) in
                        transJsonMap?["signatures"] = [sign?.substring(from: 0, length: (sign?.count ?? 1) - 1)]
                        transaction = transJsonMap?.jsonString() ?? ""
                        pushTransaction(transaction, actionModel: actionModel, callback: callback)
                    }, failed: { (failedReason) in
                        callback(false, failedReason ?? actionModel.faile)
                    })
                    return
                }
            } else if action == EOSAction.delegatebw.rawValue {
                transaction = EOSIO.getDelegateTransaction(privakey, code: EOSIOContract.EOSIOCode, from: actionModel.fromAccount, getinfo: json.rawString(), abistr: abiStr)
            } else if action == EOSAction.undelegatebw.rawValue {
                transaction = EOSIO.getUnDelegateTransaction(privakey, code: EOSIOContract.EOSIOCode, from: actionModel.fromAccount, getinfo: json.rawString(), abistr: abiStr)
            } else if action == EOSAction.buyram.rawValue {
                transaction = EOSIO.getBuyRamTransaction(privakey,
                                                         contract: EOSIOContract.EOSIOCode,
                                                         payer_str: actionModel.fromAccount,
                                                         infostr: json.rawString(),
                                                         abistr: abiStr,
                                                         max_cpu_usage_ms: 0,
                                                         max_net_usage_words: 0)
            } else if action == EOSAction.sellram.rawValue {
                transaction = EOSIO.getSellRamTransaction(privakey,
                                                          contract: EOSIOContract.EOSIOCode,
                                                          account_str: actionModel.fromAccount,
                                                          infostr: json.rawString(),
                                                          abistr: abiStr,
                                                          max_cpu_usage_ms: 0,
                                                          max_net_usage_words: 0)
            } else if action == EOSAction.voteproducer.rawValue {
                transaction = EOSIO.getVoteTransaction(privakey,
                                                       contract: EOSIOContract.EOSIOCode,
                                                       vote_str: actionModel.fromAccount,
                                                       infostr: json.rawString(),
                                                       abistr: abiStr,
                                                       max_cpu_usage_ms: 0,
                                                       max_net_usage_words: 0)
            }
            pushTransaction(transaction, actionModel: actionModel, callback: callback)
        }, error: { (_) in

        }, failure: { (_) in

        })
    }, error: { (_) in

    }) { (_) in

    }
}

func pushTransaction(_ transaction: String, actionModel: ActionModel, callback:@escaping (Bool, String) -> Void) {
    EOSIONetwork.request(target: .pushTransaction(json: transaction), success: { (data) in
        if let info = data.dictionaryObject, info["code"] == nil {
            callback(true, actionModel.success)
        } else {
            callback(false, actionModel.faile)
        }
    }, error: { (_) in
        callback(false, actionModel.faile)
    }) { (_) in
        callback(false, R.string.localizable.request_failed.key.localized() )
    }
}

func showWarning(_ str: String) {

    let rightView = UIImageView(image: R.image.icNotifyCloseWhite())
    rightView.isUserInteractionEnabled = true
    rightView.contentMode = .center

    let banner = NotificationBanner(title: "", subtitle: str, rightView: rightView, style: .danger, colors: BannerColor())
    banner.subtitleLabel?.type = .continuous
    banner.duration = 10
    rightView.rx.tapGesture().when(.recognized).subscribe(onNext: { (_) in
        banner.dismiss()
    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: banner.disposeBag)

    banner.autoDismiss = false
    banner.show()
}

func showSuccessTop(_ str: String) {
    KRProgressHUD.dismiss()

    let banner = NotificationBanner(title: "", subtitle: str, style: .success, colors: BannerColor())
    banner.duration = 2
    banner.subtitleLabel?.textAlignment = NSTextAlignment.center
    banner.autoDismiss = true
    banner.show()
}

func showFailTop(_ str: String) {
    KRProgressHUD.dismiss()

    let banner = NotificationBanner(title: "", subtitle: str, style: .warning, colors: BannerColor())
    banner.subtitleLabel?.textAlignment = NSTextAlignment.center
    banner.duration = 2

    banner.autoDismiss = true
    banner.show()
}

func endProgress() {
    KRProgressHUD.dismiss()
}

func getRamPrice(_ completion:@escaping ObjectOptionalCallback) {
    EOSIONetwork.request(target: .getTableRows(json: RamMarket().toJSONString()!), success: { (json) in
        let row = json["rows"][0]
        let base = row["base"]
        let quote = row["quote"]

        if let baseQuantity = base["balance"].stringValue.components(separatedBy: " ").first,
            let quoteQuantity = quote["balance"].stringValue.components(separatedBy: " ").first,
            let quoteWeight = quote["weight"].string {
            let unit = Decimal(string: quoteQuantity)! / Decimal(string: baseQuantity)!
            let price = unit * Decimal(string: quoteWeight)!
            Defaults.set(price.stringValue, forKey: NetworkConfiguration.RAMPriceDefaultSymbol)
            completion(price)
        }

    }, error: { (_) in
        completion(nil)

    }) { (_) in
        completion(nil)
    }
}

extension String {
    var eosAmount: String {
        if self.contains(" ") {
            if let first = self.components(separatedBy: " ").first {
                if first == "-" {
                    return ""
                }
                return first
            }
            return ""
        } else {
            return ""
        }
    }

    var hashNano: String {
        if let front = self.substring(from: 0, length: 8), let behind = self.substring(from: self.count - 8, length: 8) {
            return front + "..." + behind
        }

        return self
    }
}

extension Date {
    var refundStatus: String {
        let interval = self.addingTimeInterval(72 * 3600).timeIntervalSince(Date())
        let day = floor(interval / 86400)
        let hour = ceil((interval - day * 86400) / 3600)

        if day >= 0 && hour >= 0 {
            return String.init(format: "%@%02.0f%@%02.0f%@", R.string.localizable.rest.key.localized(), day, R.string.localizable.day.key.localized(), hour, R.string.localizable.hour.key.localized())
        } else {
            return ""
        }
    }
}

extension Int64 {
    var ramCount: String {
        return ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}

extension Int64 {
    var toKB: String {
        return (Double(self) / 1_024).string(digits: 2)
    }
}

extension Int64 {
    var toMS: String {
        return (Double(self) / 1_024).string(digits: 2)
    }
}

extension String {
    var toBytes: UInt32 {
        return UInt32((Double(self)! * 1_024))
    }
}

extension UIImage {

}

func getCurrentLanguage() -> String {
    //        let defs = UserDefaults.standard
    //        let languages = defs.object(forKey: "AppleLanguages")
    //        let preferredLang = (languages! as AnyObject).object(0)
    let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
    //        let preferredLang = (languages! as AnyObject).object(0)
    log.debug("当前系统语言:\(preferredLang)")

    switch String(describing: preferredLang) {
    case "en-US", "en-CN":
        return "en"//英文
    case "zh-Hans-US", "zh-Hans-CN", "zh-Hant-CN", "zh-TW", "zh-HK", "zh-Hans":
        return "cn"//中文
    default:
        return "en"
    }
}

func labelBaselineOffset(_ lineHeight: CGFloat, fontHeight: CGFloat) -> Float {
    return ((lineHeight - lineHeight) / 4.0).float
}

func dismiss() {
    if let vc = UIViewController.topMost {
        vc.dismiss(animated: true) {

        }
    }
}

func getNetWorkReachability() -> String {
    let data = Defaults[.NetworkReachability]
    return data
}

func saveNetWorkReachability() {
    let manager = NetworkReachabilityManager()
    switch manager?.networkReachabilityStatus {
    case .unknown?:
        Defaults[.NetworkReachability] = WifiStatus.unknown.rawValue
    case .notReachable?:
        Defaults[.NetworkReachability] = WifiStatus.notReachable.rawValue
    case .reachable?:
        if (manager?.isReachableOnWWAN)! {
            Defaults[.NetworkReachability] = WifiStatus.wwan.rawValue
        } else if (manager?.isReachableOnEthernetOrWiFi)! {
            Defaults[.NetworkReachability] = WifiStatus.wifi.rawValue
        }
    default:
        break
    }

    manager?.listener = { status in
        switch status {
        case .unknown:
            Defaults[.NetworkReachability] = WifiStatus.unknown.rawValue
        case .notReachable:
            Defaults[.NetworkReachability] = WifiStatus.notReachable.rawValue
        case .reachable:
            if (manager?.isReachableOnWWAN)! {
                Defaults[.NetworkReachability] = WifiStatus.wwan.rawValue
            } else if (manager?.isReachableOnEthernetOrWiFi)! {
                Defaults[.NetworkReachability] = WifiStatus.wifi.rawValue
            }
        }
    }
    manager?.startListening()
}

func saveUnitToLocal(rmbPrices: [JSON]) {
    var rmbStr = ""
    var usdStr = ""
    if let rmb = rmbPrices.filter({ $0["name"].stringValue == NetworkConfiguration.EOSIODefaultSymbol }).first {
        rmbStr = rmb["value"].stringValue
    }
    if let usd = rmbPrices.filter({ $0["name"].stringValue == NetworkConfiguration.USDTDefaultSymbol }).first {
        usdStr = usd["value"].stringValue
    }

    Defaults.set(rmbStr, forKey: Unit.RMBUnit)
    Defaults.set(usdStr, forKey: Unit.USDUnit)
}

func dataToDictionary(data: Data) ->Dictionary<String, Any>? {
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        let dic = json as? Dictionary<String, Any>
        return dic
    } catch _ {
        print("失败")
        return nil
    }
}

func jsonToData(jsonDic: Dictionary<String, Any>) -> Data? {
    if (!JSONSerialization.isValidJSONObject(jsonDic)) {
        print("is not a valid json object")
        return nil
    }
    //利用自带的json库转换成Data
    //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
    //Data转换成String打印输出
    let str = String(data: data!, encoding: String.Encoding.utf8)
    //输出json字符串
    print("Json Str:\(str!)")
    return data
}

//func correctAmount(_ sender:String) -> String{
//    if let _ = sender.toDouble(){
//        if sender.contains("."),let last = sender.components(separatedBy: ".").last{
//            if last.count > 4{
//                return sender.components(separatedBy: ".").first! + last.substring(from: 0, length: 4)!
//            }
//            return sender
//        }
//    }
//    return ""
//}
