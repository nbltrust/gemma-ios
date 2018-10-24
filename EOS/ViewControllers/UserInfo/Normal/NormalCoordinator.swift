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
    func openContent(_ sender: Int)
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
        reducer: NormalReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension NormalCoordinator: NormalCoordinatorProtocol {
    func openContent(_ sender: Int) {
        if let vc = R.storyboard.userInfo.normalContentViewController(), let type = CustomSettingType(rawValue: sender) {
            vc.coordinator = NormalContentCoordinator(rootVC: self.rootVC)
            vc.type = type
            self.rootVC.pushViewController(vc, animated: true)
        }
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
        case .node:
            return EOSBaseURLNodesConfiguration.values[Defaults[.currentURLNode]]
        }
    }
}
