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

protocol HomeCoordinatorProtocol {
    func pushPaymentDetail()
    func pushPayment()
    func pushWallet()
//    func pushScreenShotAlert()
    func pushAccountList()
    func pushResourceMortgageVC()
    func pushBackupVC()
}

protocol HomeStateManagerProtocol {
    var state: HomeState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<HomeState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func getAccountInfo(_ account:String)
    
    func createDataInfo() -> [LineView.LineViewModel]
    
    func checkAccount(_ completion:@escaping ResultCallback)
}

class HomeCoordinator: HomeRootCoordinator {
    
    lazy var creator = HomePropertyActionCreate()
    
    var store = Store<HomeState>(
        reducer: HomeReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    //截屏弹框测试代码
//    func pushScreenShotAlert() {
//        let width = ModalSize.custom(size: 270)
//        let height = ModalSize.custom(size: 230)
//        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: (UIScreen.main.bounds.width-270)/2, y: UIScreen.main.bounds.height/2-115))
//        let customType = PresentationType.custom(width: width, height: height, center: center)
//
//        let presenter = Presentr(presentationType: customType)
//        presenter.keyboardTranslationType = .moveUp
//
//        if let vc = R.storyboard.screenShotAlert.screenShotAlertViewController() {
//            let coordinator = ScreenShotAlertCoordinator(rootVC: self.rootVC)
//            vc.coordinator = coordinator
//            self.rootVC.topViewController?.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
//        }
//    }
    func pushBackupVC() {
        if let vc = R.storyboard.entry.backupPrivateKeyViewController() {
            let coordinator = BackupPrivateKeyCoordinator(rootVC: self.rootVC)
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
        presenter.keyboardTranslationType = .moveUp

        let newVC = BaseNavigationController()
        newVC.navStyle = .white
        let accountList = AccountListRootCoordinator(rootVC: newVC)
        
        self.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
        accountList .start()
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
    
    func getAccountInfo(_ account:String) {
        EOSIONetwork.request(target: .get_currency_balance(account: account), success: { (json) in
            self.store.dispatch(BalanceFetchedAction(balance: json))
        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        EOSIONetwork.request(target: .get_account(account: account), success: { (json) in
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(AccountFetchedAction(info: accountObj))
            }

        }, error: { (code) in
            
        }) { (error) in
            
        }
        
        SimpleHTTPService.requestETHPrice().done { (json) in
            if let eos = json.filter({ $0["name"].stringValue == NetworkConfiguration.EOSIO_DEFAULT_SYMBOL }).first {
                self.store.dispatch(RMBPriceFetchedAction(price: eos))
            }
            
        }.cauterize()
    }
    
    func createDataInfo() -> [LineView.LineViewModel] {
        return [LineView.LineViewModel.init(name: R.string.localizable.payments_history(),
                                            content: "",
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false),
                LineView.LineViewModel.init(name: R.string.localizable.resources_pledge(),
                                            content: R.string.localizable.resource_get(),
                                            image_name: R.image.icArrow.name,
                                            name_style: LineViewStyleNames.normal_name,
                                            content_style: LineViewStyleNames.normal_content,
                                            isBadge: false,
                                            content_line_number: 1,
                                            isShowLineView: false)
        ]
    }
    
    func checkAccount(_ completion:@escaping ResultCallback) {
        WalletManager.shared.validAccountRegisterSuccess(WalletManager.shared.currentPubKey, completion: completion)
    }
}
