//
//  ResourceDetailCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol ResourceDetailCoordinatorProtocol {
    func pushDelegateVC()
    func pushBuyRamVC()
}

protocol ResourceDetailStateManagerProtocol {
    var state: ResourceDetailState { get }
    
    func switchPageState(_ state:PageState)

    func getAccountInfo(_ account: String)
}

class ResourceDetailCoordinator: NavCoordinator {
    var store = Store(
        reducer: gResourceDetailReducer,
        state: nil,
        middleware:[trackingMiddleware]
    )
    
    var state: ResourceDetailState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.resourceMortgage.resourceDetailViewController()!
        let coordinator = ResourceDetailCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(ResourceDetailCoordinatorProtocol.self, observer: self)
        Broadcaster.register(ResourceDetailStateManagerProtocol.self, observer: self)
    }
}

extension ResourceDetailCoordinator: ResourceDetailCoordinatorProtocol {
    func pushDelegateVC() {
        if let deleVC = R.storyboard.resourceMortgage.resourceMortgageViewController() {
            let coordinator = ResourceMortgageCoordinator(rootVC: self.rootVC)
            deleVC.coordinator = coordinator
            self.rootVC.pushViewController(deleVC, animated: true)
        }
    }
    func pushBuyRamVC() {
        self.pushVC(BuyRamCoordinator.self, animated: true, context: nil)
    }
}

extension ResourceDetailCoordinator: ResourceDetailStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func getAccountInfo(_ account: String) {
        EOSIONetwork.request(target: .getCurrencyBalance(account: account), success: { (json) in
            CurrencyManager.shared.saveBalanceJsonWith(account, json: json)
            self.store.dispatch(MBalanceFetchedAction(balance: json))
        }, error: { (_) in

        }) { (_) in

        }

        EOSIONetwork.request(target: .getAccount(account: account, otherNode: false), success: { (json) in
            CurrencyManager.shared.saveAccountJsonWith(account, json: json)
            if let accountObj = Account.deserialize(from: json.dictionaryObject) {
                self.store.dispatch(MAccountFetchedAction(info: accountObj))
            }

        }, error: { (_) in

        }) { (_) in

        }
    }
}
