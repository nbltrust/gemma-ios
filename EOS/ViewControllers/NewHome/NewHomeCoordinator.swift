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

    func getTokensWith(_ account: String) {
        NBLNetwork.request(target: .getTokens(account: account), success: { (data) in
            let tokens = data["tokens"].arrayValue
            if let tokenArr = tokens.map({ (json) in
                Tokens.deserialize(from: json.dictionaryObject)
            }) as? [Tokens] {
                self.store.dispatch(TokensFetchedAction(data: tokenArr))
            }
        }, error: { (_) in

        }) { (_) in

        }
    }

    func getCurrencyInfo(_ currency: Currency) {
        if currency.type == .EOS {
            let names = CurrencyManager.shared.getAccountNameWith(currency.id)
            let active = CurrencyManager.shared.getActived(currency.id)
            if let names = names, active == true {
                let account = names
                EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
                    self.store.dispatch(BalanceFetchedAction(currency: currency, balance: json))
                }, error: { (_) in
                }) { (_) in
                }

                EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: {[weak self] (json) in
                    guard let `self` = self else { return }
                    if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                        self.store.dispatch(AccountFetchedAction(currency: currency, info: accountObj))
                    }
                }, error: { (_) in
                }) { (_) in
                }

                SimpleHTTPService.requestETHPrice().done { (json) in
                    self.store.dispatch(RMBPriceFetchedAction(currency: currency))
                    }.cauterize()
                self.getTokensWith(account)
            } else {
                self.store.dispatch(NonActiveFetchedAction(currency:currency))
            }

            
        } else if currency.type == .ETH {

        }

    }
}
