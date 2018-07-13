//
//  TransferCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import PromiseKit
import AwaitKit
import Presentr

protocol TransferCoordinatorProtocol {
    func pushToTransferConfirmVC(toAccount:String,money:String,remark:String)
    
}

protocol TransferStateManagerProtocol {
    var state: TransferState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func validMoney(_ money: String, blance: String)
    func validName(_ name: String)

    func fetchUserAccount(_ account:String)
    
    func transferAccounts(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool)->())
    
    func checkAccountName(_ name:String) ->(Bool,error_info:String)
}

class TransferCoordinator: TransferRootCoordinator {
    
    lazy var creator = TransferPropertyActionCreate()
    
    var store = Store<TransferState>(
        reducer: TransferReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension TransferCoordinator: TransferCoordinatorProtocol {
    func pushToTransferConfirmVC(toAccount:String,money:String,remark:String) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 369)
        let center = ModalCenterPosition.bottomCenter
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.dismissOnTap = false
        let newVC = BaseNavigationController()
        newVC.isPureWhiteNavBg = true
        let transferConfirm = TransferConfirmRootCoordinator(rootVC: newVC)
        
        self.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
//        transferConfirm .start()
        if let vc = R.storyboard.transfer.transferConfirmViewController() {
            let coordinator = TransferConfirmCoordinator(rootVC: transferConfirm.rootVC)
            vc.coordinator = coordinator
            vc.toAccount = "@" + toAccount
            vc.money = money
            vc.remark = remark
            transferConfirm.rootVC.pushViewController(vc, animated: true)
        }

        
    }
    
    
}

extension TransferCoordinator: TransferStateManagerProtocol {
    var state: TransferState {
        return store.state
    }
    
    func validMoney(_ money: String, blance: String) {
        self.store.dispatch(moneyAction(money: money, balance: blance))
    }
    
    func validName(_ name: String) {
        self.store.dispatch(toNameAction(isValid: WallketManager.shared.isValidWalletName(name)))
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func fetchUserAccount(_ account:String) {
        
        EOSIONetwork.request(target: .get_currency_balance(account: account), success: { (json) in
            self.store.dispatch(BalanceFetchedAction(balance: json))
        }, error: { (code) in
            
        }) { (error) in
            
        }
    }
    
    func checkAccountName(_ name:String) ->(Bool,error_info:String){
        return (WallketManager.shared.isValidWalletName(name),R.string.localizable.name_ph.key.localized())
    }
    
    func getInfo(callback:@escaping (String)->()){
        EOSIONetwork.request(target: .get_info, success: { (data) in
            print("get_info : \(data)")
            callback(data.stringValue)
        }, error: { (error_code) in
            
        }) { (error) in
            
        }
    }
    
    func getPushTransaction(_ password : String,account:String, amount:String, code:String ,callback:@escaping (String?)->()){
        
        getInfo { (get_info) in
            let privakey = WallketManager.shared.getCachedPriKey(password)
            let json = EOSIO.getAbiJsonString(NetworkConfiguration.EOSIO_DEFAULT_CODE, action: EOSAction.transfer.rawValue, from: WallketManager.shared.getAccount(), to: account, quantity: amount + " " + NetworkConfiguration.EOSIO_DEFAULT_SYMBOL, memo: code)

            EOSIONetwork.request(target: .abi_json_to_bin(json:json!), success: { (data) in
                let abiStr = data.stringValue
                
               let transation = EOSIO.getTransaction(privakey,
                                     code: NetworkConfiguration.EOSIO_DEFAULT_CODE,
                                     from: account,
                    to: WallketManager.shared.getAccount(),
                    quantity: amount,
                    memo: code,
                    getinfo: get_info,
                    abistr: abiStr)
                callback(transation)
            }, error: { (error_code) in
                
            }) { (error) in
                
            }
        }
        
    }
    
    func ValidingPassword(_ password : String) -> Bool{
        return WallketManager.shared.isValidPassword(password)
    }

    
    func transferAccounts(_ password:String, account:String, amount:String, code:String ,callback:@escaping (Bool)->()) {
        
        getPushTransaction(password, account: account, amount: amount, code: code,callback: { transaction in
            if let transaction = transaction {
                EOSIONetwork.request(target: .push_transaction(json: transaction), success: { (data) in
                    if let info = data.dictionaryObject,info["code"] == nil{
                        callback(true)
                    }else{
                        callback(false)
                    }
                }, error: { (error_code) in
                     callback(false)
                }) { (error) in
                    callback(false)
                }
            }
        })
    }
}
