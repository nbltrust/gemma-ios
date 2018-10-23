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
    func finishVoteNode()
}

protocol TransferConfirmPasswordStateManagerProtocol {
    var state: TransferConfirmPasswordState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmPasswordState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func transferAccounts(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func bltTransferAccounts(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func mortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func relieveMortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func buyRam(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())
    
    func sellRam(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->())

    func voteNode(_ password:String, account:String, amount:String, remark:String, producers: [String] ,callback:@escaping (Bool, String)->())

}

class TransferConfirmPasswordCoordinator: NavCoordinator {
    
    lazy var creator = TransferConfirmPasswordPropertyActionCreate()
    
    var store = Store<TransferConfirmPasswordState>(
        reducer: TransferConfirmPasswordReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.transfer.transferConfirmPasswordViewController()!
        let coordinator = TransferConfirmPasswordCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }
}

extension TransferConfirmPasswordCoordinator: TransferConfirmPasswordCoordinatorProtocol {
    func finishTransfer() {
        if let transferCoor = app_coodinator.transferCoordinator, let transferVC = transferCoor.rootVC.topViewController as? TransferViewController {
            self.rootVC.dismiss(animated: true) {
                transferVC.resetData()
            }
        }
    }
    
    func finishMortgage() {
        if let mortgageCoor = app_coodinator.homeCoordinator, let mortgageVC = mortgageCoor.rootVC.topViewController as? ResourceMortgageViewController {
            self.rootVC.dismiss(animated: true) {
                mortgageVC.resetData()
            }
        }
    }
    
    func finishBuyRam() {
        if let coor = app_coodinator.homeCoordinator, let vc = coor.rootVC.topViewController as? BuyRamViewController {
            self.rootVC.dismiss(animated: true) {
                vc.resetData()
            }
        }
    }
    
    func finishVoteNode() {
        if let coor = app_coodinator.homeCoordinator, let vc = coor.rootVC.topViewController as? VoteViewController {
            self.rootVC.dismiss(animated: true) {
                vc.coordinator?.popVC()
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
        model.success = R.string.localizable.transfer_successed.key.localized()
        model.faile = R.string.localizable.transfer_failed.key.localized()
        model.amount = amount
        model.remark = remark
        transaction(EOSAction.transfer.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
    
    func bltTransferAccounts(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = TransferActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.transfer_successed.key.localized()
        model.faile = R.string.localizable.transfer_failed.key.localized()
        model.amount = amount
        model.remark = remark
        model.type = .bluetooth
        model.confirmType = pinType
        transaction(EOSAction.bltTransfer.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
    
    func mortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = DelegateActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.mortgage_success.key.localized()
        model.faile = R.string.localizable.mortgage_failed.key.localized()
        transaction(EOSAction.delegatebw.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }

    func relieveMortgage(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = UnDelegateActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.cancel_mortgage_success.key.localized()
        model.faile = R.string.localizable.cancel_mortgage_failed.key.localized()
        transaction(EOSAction.undelegatebw.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
    
    func buyRam(_ password:String, account:String, amount:String, remark:String ,callback:@escaping (Bool, String)->()) {
        let model = BuyRamActionModel()
        model.password = password
        model.toAccount = account
        model.fromAccount = WalletManager.shared.getAccount()
        model.success = R.string.localizable.buy_ram_success.key.localized()
        model.faile = R.string.localizable.buy_ram_faile.key.localized()
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
        model.success = R.string.localizable.sell_ram_success.key.localized()
        model.faile = R.string.localizable.sell_ram_faile.key.localized()
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
        model.success = R.string.localizable.vote_successed.key.localized()
        model.faile = R.string.localizable.vote_failed.key.localized()
        model.producers = producers
        transaction(EOSAction.voteproducer.rawValue, actionModel: model) { (bool, showString) in
            callback(bool,showString)
        }
    }
}
