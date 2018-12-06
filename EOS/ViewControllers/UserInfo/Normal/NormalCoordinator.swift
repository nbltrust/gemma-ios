//
//  NormalCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults

protocol NormalCoordinatorProtocol {
    func openContent(_ indexPath: IndexPath)
    func pushToCurrencyListVC()
}

protocol NormalStateManagerProtocol {
    var state: NormalState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func contentWithSender(_ sender: CustomSettingType) -> String
}

class NormalCoordinator: NavCoordinator {

    lazy var creator = NormalPropertyActionCreate()

    var store = Store<NormalState>(
        reducer: gNormalReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension NormalCoordinator: NormalCoordinatorProtocol {
    func openContent(_ indexPath: IndexPath) {
        if indexPath.row < 2 {
            if let contentVC = R.storyboard.userInfo.normalContentViewController() {
                var type = CustomSettingType.language
                if indexPath.row == 1 {
                    type = CustomSettingType.asset
                }
                contentVC.coordinator = NormalContentCoordinator(rootVC: self.rootVC)
                contentVC.type = type
                self.rootVC.pushViewController(contentVC, animated: true)
            }
        } else {
            pushToCurrencyListVC()
        }
    }

    func pushToCurrencyListVC() {
        let context = NormalCurrencyListContext()
        pushVC(NormalCurrencyListCoordinator.self, animated: true, context: context)
    }
}

extension NormalCoordinator: NormalStateManagerProtocol {
    var state: NormalState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

    func contentWithSender(_ sender: CustomSettingType) -> String {
        var data = [String]()
        switch sender {
        case .language:
            let configuration = LanguageConfiguration()
            data = configuration.keys
            let index = configuration.indexWithValue(Defaults[.language])
            return data[index]
        case .asset:
            return CoinUnitConfiguration.values[Defaults[.coinUnit]]
        case .nodeEOS:
            return EOSBaseURLNodesConfiguration.values[Defaults[.currentEOSURLNode]]
        }
    }
}
