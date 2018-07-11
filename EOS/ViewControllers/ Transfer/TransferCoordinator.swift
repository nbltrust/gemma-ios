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

protocol TransferCoordinatorProtocol {
}

protocol TransferStateManagerProtocol {
    var state: TransferState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func fetchUserAccount()
    
    func transferAccounts(_ password:String, account:String, amount:String, code:String)
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
    
}

extension TransferCoordinator: TransferStateManagerProtocol {
    var state: TransferState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func fetchUserAccount() {
        EOSIONetwork.request(target: .get_account(account: WallketManager.shared.getAccount()), success: { (data) in
            
        }, error: { (error_code) in
            
        }) { (error) in
            
        }
    }
    
    func getInfo(callback:@escaping (String)->()){
        EOSIONetwork.request(target: .get_info, success: { (data) in
            print("get_info : \(data)")
            callback(data.stringValue)
        }, error: { (error_code) in
            
        }) { (error) in
            
        }
    }
    
    func getPushTransaction(_ password : String,account:String, amount:String, code:String) -> String {
        
        getInfo { (get_info) in
            let getinfo = get_info
        }
        
        let privakey = WallketManager.shared.getCachedPriKey(password)
        
        let json = EOSIO.getAbiJsonString(NetworkConfiguration.EOSIO_DEFAULT_CODE, action: EOSAction.transfer.rawValue, from: WallketManager.shared.getAccount(), to: account, quantity: amount + " " + NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)
        
        EOSIONetwork.request(target: .abi_json_to_bin(json:json!), success: { (data) in
            let abiStr = data
        }, error: { (error_code) in
            
        }) { (error) in
            
        }
        
        
        /**
         code -> NetworkConfiguration.EOSIO_DEFAULT_CODE
         from -> WallketManager.shared.getAccount()
         to ->   account
         quantity XX NetworkConfiguration.EOSIO_DEFAULT_SYMBOL
         memo -> 备注
         getinfo :
         abistr :
         **/
//        EOSIO.getTransaction(privakey,
//                             code: NetworkConfiguration.EOSIO_DEFAULT_CODE,
//                             from: ,
//                             to: String!,
//                             quantity: <#T##String!#>,
//                             memo: <#T##String!#>,
//                             getinfo: <#T##String!#>,
//                             abistr: <#T##String!#>)
        return ""
    }
    
    func ValidingPassword(_ password : String) -> Bool{
        return WallketManager.shared.isValidPassword(password)
    }

    
    func transferAccounts(_ password:String, account:String, amount:String, code:String) {
        
        let transaction =  getPushTransaction(password, account: account, amount: amount, code: code)
        
        
        EOSIONetwork.request(target: .push_transaction(json: transaction), success: { (data) in
            
        }, error: { (error_code) in
            
        }) { (error) in
            
        }
    }
    
}
