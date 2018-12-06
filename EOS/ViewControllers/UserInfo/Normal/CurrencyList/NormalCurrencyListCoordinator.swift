//
//  NormalCurrencyListCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/12/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol NormalCurrencyListCoordinatorProtocol {
    func pushToContenVC(_ currencyType: CurrencyType)
}

protocol NormalCurrencyListStateManagerProtocol {
    var state: NormalCurrencyListState { get }
    
    func switchPageState(_ state: PageState)
}

class NormalCurrencyListCoordinator: NavCoordinator {
    var store = Store(
        reducer: gNormalCurrencyListReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
    
    var state: NormalCurrencyListState {
        return store.state
    }
    
    override class func start(_ root: BaseNavigationController, context:RouteContext? = nil) -> BaseViewController {
        let currentVC = R.storyboard.userInfo.normalCurrencyListViewController()!
        let coordinator = NormalCurrencyListCoordinator(rootVC: root)
        currentVC.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return currentVC
    }

    override func register() {
        Broadcaster.register(NormalCurrencyListCoordinatorProtocol.self, observer: self)
        Broadcaster.register(NormalCurrencyListStateManagerProtocol.self, observer: self)
    }
}

extension NormalCurrencyListCoordinator: NormalCurrencyListCoordinatorProtocol {
    func pushToContenVC(_ currencyType: CurrencyType) {
        var type = CustomSettingType.nodeEOS
        switch currencyType {
        case .EOS:
            type = CustomSettingType.nodeEOS
        default:
            type = CustomSettingType.nodeEOS
        }
        if let contentVC = R.storyboard.userInfo.normalContentViewController() {
            contentVC.coordinator = NormalContentCoordinator(rootVC: self.rootVC)
            contentVC.type = type
            self.rootVC.pushViewController(contentVC, animated: true)
        }
    }
}

extension NormalCurrencyListCoordinator: NormalCurrencyListStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
