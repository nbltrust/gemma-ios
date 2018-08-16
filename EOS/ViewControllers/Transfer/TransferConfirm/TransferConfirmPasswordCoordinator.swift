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
    func finishBuyRam()
    func dismissConfirmPwdVC()
    func popConfirmPwdVC()
}

protocol TransferConfirmPasswordStateManagerProtocol {
    var state: TransferConfirmPasswordState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmPasswordState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func transferAccounts(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func mortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func relieveMortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func buyRam(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func sellRam(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())

    func voteNode(_ password:String, account:String, amount:String, remark:String, producers: [String] ,callback:@escaping (Bool, String)->())

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
    
    func finishBuyRam() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let coor = appDelegate.appcoordinator?.homeCoordinator, let vc = coor.rootVC.topViewController as? BuyRamViewController {
            self.rootVC.dismiss(animated: true) {
                vc.resetData()
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
    
    func ValidingPassword(_ password : String) -> Bool{
        return WalletManager.shared.isValidPassword(password)
    }
    
    
    func transferAccounts(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = TransferActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.transfer_successed()
        model.faile = R.string.localizable.transfer_failed()
        model.amount = amount
        model.remark = remark
        transaction(EOSAction.transfer.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
    
    func mortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = DelegateActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.mortgage_success()
        model.faile = R.string.localizable.mortgage_failed()
        transaction(EOSAction.delegatebw.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }

    func relieveMortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = UnDelegateActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.cancel_mortgage_success()
        model.faile = R.string.localizable.cancel_mortgage_failed()
        transaction(EOSAction.undelegatebw.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
    
    func buyRam(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = BuyRamActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.buy_ram_success()
        model.faile = R.string.localizable.buy_ram_faile()
        model.amount = amount
        transaction(EOSAction.buyram.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
    
    func sellRam(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = SellRamActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.sell_ram_success()
        model.faile = R.string.localizable.sell_ram_faile()
        model.amount = amount
        transaction(EOSAction.sellram.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
    
    func voteNode(_ password: String, account: String, amount: String, remark: String, producers: [String], callback: @escaping (Bool, String) -> ()) {
        let model = VoteProducerActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.sell_ram_success()
        model.faile = R.string.localizable.sell_ram_faile()
        model.producers = producers
        transaction(EOSAction.voteproducer.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
}
