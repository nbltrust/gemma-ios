//
//  NewHomeCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import SwiftyUserDefaults

protocol NewHomeCoordinatorProtocol {
    func pushToSetVC()
    func pushWallet()
    func pushToEntryVCWithCurrencyID(id: Int64?)
    func pushToOverviewVCWithCurrencyID(id: Int64?)
}

protocol NewHomeStateManagerProtocol {
    var state: NewHomeState { get }

    func switchPageState(_ state: PageState)

    func fetchWalletInfo(_ wallet: Wallet)
}

class NewHomeCoordinator: NavCoordinator {
    var store = Store(
        reducer: gNewHomeReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: NewHomeState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.home.newHomeViewController()!
        let coordinator = NewHomeCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(NewHomeCoordinatorProtocol.self, observer: self)
        Broadcaster.register(NewHomeStateManagerProtocol.self, observer: self)
    }
}

extension NewHomeCoordinator: NewHomeCoordinatorProtocol {
    func pushToSetVC() {
        if let vc = R.storyboard.userInfo.userInfoViewController() {
            let coordinator = UserInfoCoordinator(rootVC: self.rootVC)
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

    func pushToEntryVCWithCurrencyID(id: Int64?) {
        if let vc = R.storyboard.entry.entryViewController() {
            vc.createType = .EOS
            vc.currencyID = id
            let coordinator = EntryCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }

    func pushToOverviewVCWithCurrencyID(id: Int64?) {
        if let vc = R.storyboard.home.overviewViewController() {
            vc.currencyID = id
            let coordinator = OverviewCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension NewHomeCoordinator: NewHomeStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func fetchWalletInfo(_ wallet: Wallet) {
        do {
            let curArray: [Currency] = try WalletCacheService.shared.fetchAllCurrencysBy(wallet) ?? []
            if curArray.count > 0 {
                for currency in curArray {
                    getCurrencyInfo(currency)
                }
            }

        } catch {

        }
    }

    func getCurrencyInfo(_ currency: Currency) {
        if currency.type == .EOS {
            let names = CurrencyManager.shared.getAccountNameWith(currency.id)
            if let names = names {
                let account = names
                let currencyID = currency.id
                EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
                    CurrencyManager.shared.saveBalanceJsonWith(currencyID, json: json)
                    self.store.dispatch(BalanceFetchedAction(currencyID: currencyID))
                }, error: { (_) in
                    self.store.dispatch(BalanceFetchedAction(currencyID: currencyID))
                }) { (_) in
                    self.store.dispatch(BalanceFetchedAction(currencyID: currencyID))
                }

                EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: { (json) in
                    CurrencyManager.shared.saveAccountJsonWith(currencyID, json: json)
                    self.store.dispatch(AccountFetchedAction(currencyID: currencyID))
                }, error: { (_) in
                    self.store.dispatch(AccountFetchedAction(currencyID: currencyID))
                }) { (_) in
                    self.store.dispatch(AccountFetchedAction(currencyID: currencyID))
                }

                SimpleHTTPService.requestETHPrice().done { (json) in
                    CurrencyManager.shared.savePriceJsonWith(currencyID, json: json)
                    self.store.dispatch(RMBPriceFetchedAction(currencyID: currencyID))
                    }.cauterize()
            } else {
                self.store.dispatch(NonActiveFetchedAction(currency:currency))
            }

            
        } else if currency.type == .ETH {

        }

    }
}
