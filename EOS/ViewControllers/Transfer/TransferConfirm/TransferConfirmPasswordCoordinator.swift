//
//  TransferConfirmPasswordCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol TransferConfirmPasswordCoordinatorProtocol {
    func finishTransfer()
    func finishMortgage()
    func dismissConfirmPwdVC()
    func popConfirmPwdVC()
}

protocol TransferConfirmPasswordStateManagerProtocol {
    var state: TransferConfirmPasswordState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmPasswordState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func transferAccounts(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool, String)->())
    
    func mortgage(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool, String)->())
    
    func relieveMortgage(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool, String)->())

}

class TransferConfirmPasswordCoordinator: TransferConfirmPasswordRootCoordinator {
    
    lazy var creator = TransferConfirmPasswordPropertyActionCreate()
    
    var store = Store<TransferConfirmPasswordState>(
        reducer: TransferConfirmPasswordReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension TransferConfirmPasswordCoordinator: TransferConfirmPasswordCoordinatorProtocol {
    func finishTransfer() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let transferCoor = appDelegate.appcoordinator?.transferCoordinator, let transferVC = transferCoor.rootVC.topViewController as? TransferViewController {
            self.rootVC.dismiss(animated: true) {
                transferVC.resetData()
            }
        }
    }
    
    func finishMortgage() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let mortgageCoor = appDelegate.appcoordinator?.homeCoordinator, let mortgageVC = mortgageCoor.rootVC.topViewController as? ResourceMortgageViewController {
            self.rootVC.dismiss(animated: true) {
                mortgageVC.resetData()
            }
        }
    }
    
    func dismissConfirmPwdVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }
    
    func popConfirmPwdVC() {
        self.rootVC.popViewController()
    }
}

extension TransferConfirmPasswordCoordinator: TransferConfirmPasswordStateManagerProtocol {
    var state: TransferConfirmPasswordState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmPasswordState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func getInfo(callback:@escaping (String)->()){
        EOSIONetwork.request(target: .get_info, success: { (data) in
            if let info = data.rawString() {
                callback(info)
            }
        }, error: { (error_code) in
            
        }) { (error) in
            
        }
    }
    
    func getPushTransaction(_ password : String,account:String, amount:String, code:String ,callback:@escaping ((String?, String))->()){
        
        getInfo { (get_info) in
            guard let privakey = WalletManager.shared.getCachedPriKey(WalletManager.shared.currentPubKey, password: password) else {
                return callback((nil, R.string.localizable.password_not_match()))
            }
            
            let json = EOSIO.getAbiJsonString(EOSIOContract.TOKEN_CODE, action: EOSAction.transfer.rawValue, from: WalletManager.shared.getAccount(), to: account, quantity: amount + " " + NetworkConfiguration.EOSIO_DEFAULT_SYMBOL, memo: code)
            
            EOSIONetwork.request(target: .abi_json_to_bin(json:json!), success: { (data) in
                let abiStr = data["binargs"].stringValue
                
                let transation = EOSIO.getTransferTransaction(privakey,
                                                      code: EOSIOContract.TOKEN_CODE,
                                                      from: WalletManager.shared.getAccount(),
                                                      getinfo: get_info,
                                                      abistr: abiStr)
                
                callback((transation,""))
            }, error: { (error_code) in
                callback((nil, R.string.localizable.request_failed()))
            }) { (error) in
                callback((nil, R.string.localizable.request_failed()))
            }
        }
        
    }
    
    func ValidingPassword(_ password : String) -> Bool{
        return WalletManager.shared.isValidPassword(password)
    }
    
    
    func transferAccounts(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool, String)->()) {
        
        getPushTransaction(password, account: account, amount: amount, code: code,callback: { transaction in
            if let transaction = transaction.0 {
                EOSIONetwork.request(target: .push_transaction(json: transaction), success: { (data) in
                    if let info = data.dictionaryObject,info["code"] == nil{
                        callback(true, R.string.localizable.transfer_successed())
                    }else{
                        callback(false, R.string.localizable.transfer_failed())
                    }
                }, error: { (error_code) in
                    callback(false, R.string.localizable.transfer_failed())
                }) { (error) in
                    callback(false,R.string.localizable.request_failed() )
                }
            }
            else {
                callback(false, transaction.1)
            }
        })
    }
    
    func mortgage(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool, String)->()) {
        EOSIONetwork.request(target: .get_info, success: { (json) in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let vc = appDelegate.appcoordinator?.homeCoordinator.rootVC.topViewController as? ResourceMortgageViewController {
                    var cpuValue = ""
                    var netValue = ""
                    if let cpu = vc.coordinator?.state.property.cpuMoneyValid.value.2 {
                        cpuValue = cpu + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
                    }
                    if let net = vc.coordinator?.state.property.netMoneyValid.value.2 {
                        netValue = net + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
                    }
                    
                    guard let abi = EOSIO.getDelegateAbi(EOSIOContract.EOSIO_CODE, action: EOSAction.delegatebw.rawValue, from: account, receiver: account, stake_net_quantity: netValue, stake_cpu_quantity: cpuValue) else {
                        callback(false, "")
                        return
                    }
                    
                    EOSIONetwork.request(target: .abi_json_to_bin(json: abi), success: { (bin_json) in
                        if let delegate = EOSIO.getDelegateTransaction(WalletManager.shared.getCachedPriKey(WalletManager.shared.getCurrentSavedPublicKey(), password: password), code: EOSIOContract.EOSIO_CODE, from: account, getinfo: json.rawString(), abistr: bin_json["binargs"].stringValue) {
                            EOSIONetwork.request(target: .push_transaction(json: delegate), success: { (data) in
                                if let info = data.dictionaryObject,info["code"] == nil{
                                    callback(true, R.string.localizable.mortgage_success())
                                }else{
                                    callback(false, R.string.localizable.mortgage_failed())
                                }
                            }, error: { (error_code) in
                                callback(false, R.string.localizable.mortgage_failed())
                            }) { (error) in
                                callback(false,R.string.localizable.request_failed() )
                            }
                        }
                    }, error: { (code) in
                        
                    }, failure: { (error) in
                        
                    })
                    
                    
                }
            }
        }, error: { (code) in
            
        }) { (error) in
            
        }
    }

    func relieveMortgage(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool, String)->()) {
        EOSIONetwork.request(target: .get_info, success: { (json) in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let vc = appDelegate.appcoordinator?.homeCoordinator.rootVC.topViewController as? ResourceMortgageViewController {
                    var cpuValue = ""
                    var netValue = ""
                    if let cpu = vc.coordinator?.state.property.cpuReliveMoneyValid.value.2 {
                        cpuValue = cpu + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
                    }
                    if let net = vc.coordinator?.state.property.netReliveMoneyValid.value.2 {
                        netValue = net + " \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
                    }
                    let abi = EOSIO.getUnDelegateAbi(EOSIOContract.EOSIO_CODE, action: EOSAction.delegatebw.rawValue, from: account, receiver: account, unstake_net_quantity: netValue, unstake_cpu_quantity: cpuValue)
                    if let delegate = EOSIO.getUnDelegateTransaction(WalletManager.shared.getCachedPriKey(WalletManager.shared.getCurrentSavedPublicKey(), password: password), code: EOSIOContract.EOSIO_CODE, from: account, getinfo: json.rawString(), abistr: abi) {
                        EOSIONetwork.request(target: .push_transaction(json: delegate), success: { (data) in
                            if let info = data.dictionaryObject,info["code"] == nil{
                                callback(true, R.string.localizable.cancel_mortgage_success())
                            }else{
                                callback(false, R.string.localizable.cancel_mortgage_failed())
                            }
                        }, error: { (error_code) in
                            callback(false, R.string.localizable.cancel_mortgage_failed())
                        }) { (error) in
                            callback(false,R.string.localizable.request_failed() )
                        }
                    }
                }
            }
        }, error: { (code) in
            
        }) { (error) in
            
        }
    }
}
