//
//  HomeCoordinator.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr
import SwiftyJSON
import NBLCommonModule
import SwiftyUserDefaults

protocol HomeCoordinatorProtocol {
    func pushPaymentDetail()
    func pushPayment()
    func pushWallet()
    func pushAccountList(_ complication: CompletionCallback)
    func pushResourceMortgageVC()
    func pushBackupVC()
    func pushBuyRamVC()
    func pushVoteVC()
    func pushDealRAMVC()
}

protocol HomeStateManagerProtocol {
    var state: HomeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func getAccountInfo(_ account: String)

    func createDataInfo() -> [LineView.LineViewModel]

    func checkAccount()

    func getCurrentFromLocal()

    func isBluetoothWallet() -> Bool

    func bluetoothDataInfo() -> LineView.LineViewModel

    func handleBluetoothDevice()
}

class HomeCoordinator: NavCoordinator {

    lazy var creator = HomePropertyActionCreate()

    var store = Store<HomeState>(
        reducer: gHomeReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.home.homeViewController()!
        let coordinator = HomeCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))

        return vc
    }
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    func pushBackupVC() {
        if let vc = R.storyboard.entry.backupPrivateKeyViewController() {
            let coordinator = BackupPrivateKeyCoordinator(rootVC: self.rootVC)
            coordinator.state.callback.hadSaveCallback.accept {[weak self] in
                guard let `self` = self else { return }
                self.rootVC.popToRootViewController(animated: true)
            }
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushAccountList(_ complication: () -> Void) {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 272)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 272))
        let customType = PresentationType.custom(width: width, height: height, center: center)

        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .stickToTop

        presentVC(AccountListCoordinator.self, animated: true, context: nil, navSetup: { (nav) in
            nav.navStyle = .common
        }) { (top, target) in
            top.customPresentViewController(presenter, viewController: target, animated: true, completion: nil)
        }
    }

    func pushPaymentDetail() {
        if let vc = R.storyboard.paymentsDetail.paymentsDetailViewController() {
            let coordinator = PaymentsDetailCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushPayment() {
        if let vc = R.storyboard.payments.paymentsViewController() {
            let coordinator = PaymentsCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushWallet() {
        if let vc = R.storyboard.wallet.walletViewController() {
            let coordinator = WalletCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushResourceMortgageVC() {
        if let vc = R.storyboard.resourceMortgage.resourceMortgageViewController() {
            let coordinator = ResourceMortgageCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushBuyRamVC() {
        self.pushVC(BuyRamCoordinator.self, animated: true, context: nil)
    }

    func pushVoteVC() {
        if let vc = R.storyboard.home.voteViewController() {
            let coordinator = VoteCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushDealRAMVC() {

    }
}

extension HomeCoordinator: HomeStateManagerProtocol {
    var state: HomeState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

//    func getAccountFromLocal() {
//
//        if let jsonStr = Defaults.object(forKey: CurrencyManager.shared.getCurrentAccountName()) as? String {
//            if let accountObj = Account.deserialize(from: jsonStr) {
//                self.store.dispatch(AccountFetchedAction(info: accountObj))
//            }
//        }
//    }

    func getAccountInfo(_ account: String) {
        EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
            self.store.dispatch(BalanceFetchedAction(currency: nil))
        }, error: { (_) in
            self.store.dispatch(BalanceFetchedAction(currency: nil))
        }) { (_) in
            self.store.dispatch(BalanceFetchedAction(currency: nil))
        }

        EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: { (json) in
            self.store.dispatch(AccountFetchedAction(currency: nil))
        }, error: { (_) in
            self.store.dispatch(AccountFetchedAction(currency: nil))
        }) { (_) in
            self.store.dispatch(AccountFetchedAction(currency: nil))
        }

        SimpleHTTPService.requestETHPrice().done { (json) in
            self.store.dispatch(RMBPriceFetchedAction(currency: nil))
        }.cauterize()
    }

    func createDataInfo() -> [LineView.LineViewModel] {
        return [LineView.LineViewModel.init(name: R.string.localizable.payments_history.key.localized(),
                                            content: "",
                                            imageName: R.image.icArrow.name,
                                            nameStyle: LineViewStyleNames.normalName,
                                            contentStyle: LineViewStyleNames.normalContent,
                                            isBadge: false,
                                            contentLineNumber: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.node_vote.key.localized(),
                                            content: "",
                                            imageName: R.image.icArrow.name,
                                            nameStyle: LineViewStyleNames.normalName,
                                            contentStyle: LineViewStyleNames.normalContent,
                                            isBadge: false,
                                            contentLineNumber: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.deal_ram.key.localized(),
                                            content: "",
                                            imageName: R.image.icArrow.name,
                                            nameStyle: LineViewStyleNames.normalName,
                                            contentStyle: LineViewStyleNames.normalContent,
                                            isBadge: false,
                                            contentLineNumber: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.resource_manager.key.localized(),
                                            content: R.string.localizable.resource_manager.key.localized(),
                                            imageName: R.image.icArrow.name,
                                            nameStyle: LineViewStyleNames.normalName,
                                            contentStyle: LineViewStyleNames.normalContent,
                                            isBadge: false,
                                            contentLineNumber: 1,
                                            isShowLineView: false)
        ]
    }

    func checkAccount() {
//        WalletManager.shared.checkCurrentWallet()
    }

    func getCurrentFromLocal() {
        
    }

    func isBluetoothWallet() -> Bool {
        if let currentWallet = WalletManager.shared.currentWallet() {
            return currentWallet.type == .bluetooth
        }
        return false
    }

    func bluetoothDataInfo() -> LineView.LineViewModel {
        let isConnection = BLTWalletIO.shareInstance()?.isConnection() ?? false
        let connection = R.string.localizable.wookong_connect_successed.key.localized()
        let unConnection = R.string.localizable.wookong_connect_none.key.localized()

        return LineView.LineViewModel.init(name: R.string.localizable.wookong_title.key.localized(),
                                        content: isConnection ? connection : unConnection,
                                      imageName: R.image.icArrow.name,
                                      nameStyle: LineViewStyleNames.normalName,
                                   contentStyle: LineViewStyleNames.normalContent,
                                        isBadge: false,
                              contentLineNumber: 1,
                                 isShowLineView: false)
    }

    func handleBluetoothDevice() {

    }
}
