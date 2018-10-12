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
    func pushToTransferConfirmVC(data: ConfirmViewModel)
    func pushToPaymentVC()
}

protocol TransferStateManagerProtocol {
    var state: TransferState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func validMoney(_ money: String, blance: String)
    func validName(_ name: String)

    func fetchUserAccount(_ account:String)
    
    func checkAccountName(_ name:String) ->(Bool,error_info:String)
    func getCurrentFromLocal()
}

class TransferCoordinator: NavCoordinator {
    var store = Store<TransferState>(
        reducer: TransferReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.transfer.transferViewController()!
        let coordinator = TransferCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }
}

extension TransferCoordinator: TransferCoordinatorProtocol {
    func pushToPaymentVC() {
        let vc = R.storyboard.payments.paymentsViewController()!
        let coor = PaymentsCoordinator(rootVC: self.rootVC)
        vc.coordinator = coor
        self.rootVC.pushViewController(vc, animated: true)
        
    }
    
    func pushToTransferConfirmVC(data: ConfirmViewModel) {
        let isBltWallet = WalletManager.shared.isBluetoothWallet()
        if isBltWallet && !(BLTWalletIO.shareInstance()?.isConnection() ?? false) {
            let width = ModalSize.full
            let height = ModalSize.custom(size: 180)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 180))
            let customType = PresentationType.custom(width: width, height: height, center: center)

            let presenter = Presentr(presentationType: customType)
            presenter.dismissOnTap = false
            presenter.keyboardTranslationType = .stickToTop

            var context = BLTCardConnectContext()
            context.connectSuccessed = { [weak self] in
                guard let `self` = self else { return }
                self.showComfirmVC(data: data, type: .bluetooth)
            }

            presentVC(BLTCardConnectCoordinator.self, animated: true, context: context, navSetup: { (nav) in
                nav.navStyle = .white
            }) { (top, target) in
                top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
            }
        } else {
            showComfirmVC(data: data, type: isBltWallet ? .bluetooth :.gemma)
        }
    }
    
    func showComfirmVC(data: ConfirmViewModel, type: CreateAPPId) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 369)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 369))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.dismissOnTap = false
        presenter.keyboardTranslationType = .stickToTop
        
        var context = TransferConfirmContext()
        context.data = data
        context.type = type
        
        presentVC(TransferConfirmCoordinator.self, animated: true, context: context, navSetup: { (nav) in
            nav.navStyle = .white
        }) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
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
        self.store.dispatch(toNameAction(isValid: WalletManager.shared.isValidWalletName(name)))
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
        return (WalletManager.shared.isValidWalletName(name),R.string.localizable.name_ph.key.localized())
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
            let privakey = WalletManager.shared.getCachedPriKey(WalletManager.shared.currentPubKey, password: password)
            let json = EOSIO.getAbiJsonString(EOSIOContract.TOKEN_CODE, action: EOSAction.transfer.rawValue, from: WalletManager.shared.getAccount(), to: account, quantity: amount + " " + NetworkConfiguration.EOSIO_DEFAULT_SYMBOL, memo: code)

            EOSIONetwork.request(target: .abi_json_to_bin(json:json!), success: { (data) in
                let abiStr = data.stringValue
                
               let transation = EOSIO.getTransferTransaction(privakey,
                                     code: EOSIOContract.TOKEN_CODE,
                                     from: account,
                    getinfo: get_info,
                    abistr: abiStr)
                callback(transation)
            }, error: { (error_code) in
                
            }) { (error) in
                
            }
        }
        
    }
    
    func ValidingPassword(_ password : String) -> Bool{
        return WalletManager.shared.isValidPassword(password)
    }
    
    func getCurrentFromLocal() {
        let model = WalletManager.shared.getAccountModelsWithAccountName(name: WalletManager.shared.getAccount())
        self.store.dispatch(AccountFetchedFromLocalAction(model: model))
    }
}
