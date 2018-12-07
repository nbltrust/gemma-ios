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
import SwiftyJSON

protocol NewHomeCoordinatorProtocol {
    func presentSettingVC()
    func presentWalletVC()
    func pushToEntryVCWithCurrencyID(currencyId: Int64?)
    func pushToOverviewVCWithCurrencyID(currencyId: Int64?)
}

protocol NewHomeStateManagerProtocol {
    var state: NewHomeState { get }

    func switchPageState(_ state: PageState)

    func fetchWalletInfo(_ wallet: Wallet)

    func checkEOSCurrency(_ complecation: @escaping () -> Void)
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
    func presentSettingVC() {
        if let userInfoVC = R.storyboard.userInfo.userInfoViewController() {
            let userInfoNav = BaseNavigationController.init(rootViewController: userInfoVC)
            let coordinator = UserInfoCoordinator(rootVC: userInfoNav)
            userInfoVC.coordinator = coordinator
            self.rootVC.present(userInfoNav, animated: true, completion: nil)
        }
    }

    func presentWalletVC() {
        if let walletVC = R.storyboard.wallet.walletViewController() {
            let walletNav = BaseNavigationController.init(rootViewController: walletVC)
            let coordinator = WalletCoordinator(rootVC: walletNav)
            walletVC.coordinator = coordinator
            self.rootVC.present(walletNav, animated: true, completion: nil)
        }
    }

    func pushToEntryVCWithCurrencyID(currencyId: Int64?) {
        if let entryVC = R.storyboard.entry.entryViewController() {
            var isWookong = false
            if let wallet = WalletManager.shared.currentWallet(),wallet.type == .bluetooth {
                isWookong = true
            }
            entryVC.createType = isWookong ? .wookong : .EOS
            entryVC.currencyID = currencyId
            let coordinator = EntryCoordinator(rootVC: self.rootVC)
            entryVC.coordinator = coordinator
            self.rootVC.pushViewController(entryVC, animated: true)
        }
    }

    func pushToOverviewVCWithCurrencyID(currencyId: Int64?) {
        if let overViewVC = R.storyboard.home.overviewViewController() {
            overViewVC.currencyID = currencyId
            let coordinator = OverviewCoordinator(rootVC: self.rootVC)
            overViewVC.coordinator = coordinator
            self.rootVC.pushViewController(overViewVC, animated: true)
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
        self.checkEOSCurrency { [weak self] in
            guard let `self` = self else {return}
            do {
                let curArray: [Currency] = try WalletCacheService.shared.fetchAllCurrencysBy(wallet) ?? []
                if curArray.count > 0 {
                    for currency in curArray {
                        self.getCurrencyInfo(currency)
                    }
                }
            } catch {

            }
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
            let name = CurrencyManager.shared.getAccountNameWith(currency.id)
            let active = CurrencyManager.shared.getActived(currency.id)
            if let name = name, active == .actived {
                let account = name
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
                    CurrencyManager.shared.savePriceJsonWith(currency.id, json: json)
                    self.store.dispatch(RMBPriceFetchedAction(currency: currency))
                    }.cauterize()
                self.getTokensWith(account)
            } else if let name = name, active == .doActive  {
                if let actionId = Defaults[name] as? String {
                    self.store.dispatch(DoActiveFetchedAction(currency:currency, actions: nil))
                    WalletManager.shared.getActionStatus(currency, actionId: actionId) {[weak self] (result) in
                        guard let `self` = self else { return }
                        if let resultJson = result as? JSON, let actions = Actions.deserialize(from: resultJson.dictionaryObject) {
                            self.store.dispatch(DoActiveFetchedAction(currency:currency, actions: actions))
                        }
                    }
                }
            } else {
                self.store.dispatch(NonActiveFetchedAction(currency:currency))
            }
        } else if currency.type == .ETH {

        }

    }

    func checkEOSCurrency(_ complecation: @escaping () -> Void) {
        if let wallet = WalletManager.shared.currentWallet() {
            let currencies = CurrencyManager.shared.getAllCurrencys(wallet)
            for currency in currencies {
                if currency.type == .EOS {
                    if let currencyId = currency.id {
                        if CurrencyManager.shared.getActived(currencyId) == .doActive {
                            complecation()
                            return
                        }
                        CurrencyManager.shared.getEOSAccountNames(currency.pubKey ?? "", completion: { (result, accounts) in
                            if result {
                                if accounts.count > 0 {
                                    if let currentAccount = CurrencyManager.shared.getAccountNameWith(currencyId) {
                                        if !accounts.contains(currentAccount) {
                                        CurrencyManager.shared.saveAccountNameWith(currencyId, name: accounts[0])
                                        }
                                    } else {
                                        CurrencyManager.shared.saveAccountNameWith(currencyId, name: accounts[0])
                                    }
                                    CurrencyManager.shared.saveAccountNamesWith(currencyId, accounts: accounts)
                                    CurrencyManager.shared.saveActived(currencyId, actived: .actived)
                                } else {
                                    CurrencyManager.shared.saveAccountNameWith(currencyId, name: "")
                                    CurrencyManager.shared.saveAccountNamesWith(currencyId, accounts: [])
                                    CurrencyManager.shared.saveActived(currencyId, actived: .nonActived)
                                }
                            }
                            complecation()
                        })
                    }
                }
            }
        }
    }
}
