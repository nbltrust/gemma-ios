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
            let names = Defaults["accountNames\(currency.id!)"]
            if let names = names as? [String], names.count != 0 {
                let account = names[0]
                let currencyID = currency.id
                EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
                    self.store.dispatch(BalanceFetchedAction(balance: json, currencyID: currencyID))
                }, error: { (_) in
                    self.store.dispatch(BalanceFetchedAction(balance: nil, currencyID: nil))
                }) { (_) in
                    self.store.dispatch(BalanceFetchedAction(balance: nil, currencyID: nil))
                }

                EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: { (json) in
                    if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                        self.store.dispatch(AccountFetchedAction(info: accountObj, currencyID: currencyID))
                    }

                }, error: { (_) in
                    self.store.dispatch(AccountFetchedAction(info: nil, currencyID: nil))
                }) { (_) in
                    self.store.dispatch(AccountFetchedAction(info: nil, currencyID: nil))
                }

                SimpleHTTPService.requestETHPrice().done { (json) in

                    if let eos = json.filter({ $0["name"].stringValue == NetworkConfiguration.EOSIODefaultSymbol }).first {
                        if coinType() == .CNY {
                            self.store.dispatch(RMBPriceFetchedAction(price: eos, otherPrice: nil, currencyID: currencyID))
                        } else if coinType() == .USD, let usd = json.filter({ $0["name"].stringValue == NetworkConfiguration.USDTDefaultSymbol }).first {
                            self.store.dispatch(RMBPriceFetchedAction(price: eos, otherPrice: usd, currencyID: currencyID))
                        }
                    }

                    }.cauterize()
            } else {
                self.store.dispatch(LocalFetchedAction(currency:currency))
            }

            
        } else if currency.type == .ETH {

        }

    }
}
