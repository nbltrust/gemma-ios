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
            guard let privakey = WallketManager.shared.getCachedPriKey(password) else {
                return callback((nil, R.string.localizable.password_not_match()))
            }
            
            let json = EOSIO.getAbiJsonString(NetworkConfiguration.EOSIO_DEFAULT_CODE, action: EOSAction.transfer.rawValue, from: WallketManager.shared.getAccount(), to: account, quantity: amount + " " + NetworkConfiguration.EOSIO_DEFAULT_SYMBOL, memo: code)
            
            EOSIONetwork.request(target: .abi_json_to_bin(json:json!), success: { (data) in
                let abiStr = data["binargs"].stringValue
                
                let transation = EOSIO.getTransaction(privakey,
                                                      code: NetworkConfiguration.EOSIO_DEFAULT_CODE,
                                                      from: WallketManager.shared.getAccount(),
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
        return WallketManager.shared.isValidPassword(password)
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
        
    }

    func relieveMortgage(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool, String)->()) {
        
    }
}
