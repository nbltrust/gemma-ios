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
import Presentr
import eos_ios_core_cpp

protocol TransferCoordinatorProtocol {
    func pushToTransferConfirmVC(data: ConfirmViewModel, model: AssetViewModel?)
    func popVC()
}

protocol TransferStateManagerProtocol {
    var state: TransferState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func validMoney(_ money: String, blance: String)
    func validName(_ name: String)

    func fetchUserAccount(_ account: String)

    func checkAccountName(_ name: String) -> (Bool, error_info: String)
    func getCurrentFromLocal()
}

class TransferCoordinator: NavCoordinator {
    var store = Store<TransferState>(
        reducer: gTransferReducer,
        state: nil,
        middleware: [trackingMiddleware]
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
    func popVC() {
        self.rootVC.popViewController()
    }

    func pushToTransferConfirmVC(data: ConfirmViewModel, model: AssetViewModel?) {
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
                self.showComfirmVC(data: data, type: .bluetooth, model: model)
            }

            presentVC(BLTCardConnectCoordinator.self, animated: true, context: context, navSetup: { (nav) in
                nav.navStyle = .common
            }) { (top, target) in
                top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
            }
        } else {
            showComfirmVC(data: data, type: isBltWallet ? .bluetooth :.gemma, model: model)
        }
    }

    func showComfirmVC(data: ConfirmViewModel, type: CreateAPPId, model: AssetViewModel?) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 399)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 399))
        let customType = PresentationType.custom(width: width, height: height, center: center)

        let presenter = Presentr(presentationType: customType)
        presenter.dismissOnTap = false
        presenter.keyboardTranslationType = .stickToTop

        var context = TransferConfirmContext()
        context.data = data
        context.type = type
        if let model = model {
            context.model = model
        }
        presentVC(TransferConfirmCoordinator.self, animated: true, context: context, navSetup: { (nav) in
            nav.navStyle = .common
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
        self.store.dispatch(MoneyAction(money: money, balance: blance))
    }

    func validName(_ name: String) {
        self.store.dispatch(ToNameAction(isValid: WalletManager.shared.isTransferValidWalletName(name)))
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

    func fetchUserAccount(_ account: String) {

        EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
            if let id = CurrencyManager.shared.getCurrentCurrencyID() {
                self.store.dispatch(TBalanceFetchedAction(account: account))
            }
        }, error: { (_) in

        }) { (_) in

        }
    }

    func checkAccountName(_ name: String) -> (Bool, error_info: String) {
        return (WalletManager.shared.isTransferValidWalletName(name), R.string.localizable.name_ph.key.localized())
    }

    func getInfo(callback:@escaping (String) -> Void) {
        EOSIONetwork.request(target: .getInfo, success: { (data) in
            print("get_info : \(data)")
            callback(data.stringValue)
        }, error: { (_) in

        }) { (_) in

        }
    }

    func validingPassword(_ password: String) -> Bool {
        return WalletManager.shared.isValidPassword(password)
    }

    func getCurrentFromLocal() {
        
    }
}
