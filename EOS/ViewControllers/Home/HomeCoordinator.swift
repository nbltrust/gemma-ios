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
    func pushAccountList()
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
    
    func getAccountInfo(_ account:String)
    
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
        reducer: HomeReducer,
        state: nil,
        middleware:[TrackingMiddleware]
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
    
    func pushAccountList() {
        let width = ModalSize.full
        let height = ModalSize.custom(size: 272)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - 272))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .stickToTop

        presentVC(AccountListCoordinator.self, animated: true, context: nil, navSetup: { (nav) in
            nav.navStyle = .white
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
    
    func getAccountFromLocal() {
        
        if let jsonStr = Defaults.object(forKey: WalletManager.shared.getAccount()) as? String {
            if let accountObj = Account.deserialize(from: jsonStr) {
                self.store.dispatch(AccountFetchedAction(info: accountObj))
            }
        }
    }
    
    func getAccountInfo(_ account:String) {
        EOSIONetwork.request(target: .get_currency_balance(account: account), success: { (json) in
            self.store.dispatch(BalanceFetchedAction(balance: json))
        }, error: { (code) in
            self.store.dispatch(BalanceFetchedAction(balance: nil))
        }) { (error) in
            self.store.dispatch(BalanceFetchedAction(balance: nil))
        }
        
        EOSIONetwork.request(target: .get_account(account: account, otherNode: false), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(AccountFetchedAction(info: accountObj))
            }

        }, error: { (code) in
            self.store.dispatch(AccountFetchedAction(info: nil))
        }) { (error) in
            self.store.dispatch(AccountFetchedAction(info: nil))
        }
        
        SimpleHTTPService.requestETHPrice().done { (json) in
            
            if let eos = json.filter({ $0["name"].stringValue == NetworkConfiguration.EOSIO_DEFAULT_SYMBOL }).first {
                if coinType() == .CNY {
                    self.store.dispatch(RMBPriceFetchedAction(price: eos, otherPrice: nil))
                } else if coinType() == .USD, let usd = json.filter({ $0["name"].stringValue == NetworkConfiguration.USDT_DEFAULT_SYMBOL }).first {
                    self.store.dispatch(RMBPriceFetchedAction(price: eos, otherPrice: usd))
                }
            }
            
        }.cauterize()
    }
    
    func createDataInfo() -> [LineView.LineViewModel] {
        return [LineView.LineViewModel.init(name: R.string.localizable.payments_history.key.localized(),
                                            content: "",
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.node_vote.key.localized(),
                                            content: "",
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.deal_ram.key.localized(),
                                            content: "",
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.resource_manager.key.localized(),
                                            content: R.string.localizable.resource_get.key.localized(),
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false)
        ]
    }
    
    func checkAccount() {
        WalletManager.shared.checkCurrentWallet()
    }
    
    func getCurrentFromLocal() {
        let model = WalletManager.shared.getAccountModelsWithAccountName(name: WalletManager.shared.getAccount())
        self.store.dispatch(AccountFetchedFromLocalAction(model: model))
    }
    
    func isBluetoothWallet() -> Bool {
        if let currentWallet = WalletManager.shared.currentWallet() {
            return currentWallet.type == .bluetooth
        }
        return false
    }
    
    func bluetoothDataInfo() -> LineView.LineViewModel {
        return LineView.LineViewModel.init(name: R.string.localizable.wookong_title.key.localized(),
                                    content: "",
                                    image_name: R.image.icArrow.name,
                                    name_style: LineViewStyleNames.normal_name,
                                    content_style: LineViewStyleNames.normal_content,
                                    isBadge: false,
                                    content_line_number: 1,
                                    isShowLineView: false)
    }
    
    func handleBluetoothDevice() {
        
    }
}
