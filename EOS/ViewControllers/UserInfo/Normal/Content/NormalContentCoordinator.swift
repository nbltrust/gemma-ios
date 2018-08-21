//
//  NormalContentCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import SwiftyUserDefaults
import Localize_Swift

protocol NormalContentCoordinatorProtocol {
    func popVC()
}

protocol NormalContentStateManagerProtocol {
    var state: NormalContentState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalContentState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func settingDatas(_ sender : CustomSettingType) -> [String]
    
    func selectedIndex(_ sender : CustomSettingType) -> Int
    
    func setSelectIndex(_ sender : CustomSettingType, index: Int)
}

class NormalContentCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = NormalContentPropertyActionCreate()
    
    var store = Store<NormalContentState>(
        reducer: NormalContentReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension NormalContentCoordinator: NormalContentCoordinatorProtocol {
    func popVC() {
        self.rootVC.popViewController(animated: true)
    }
}

extension NormalContentCoordinator: NormalContentStateManagerProtocol {
    var state: NormalContentState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<NormalContentState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func settingDatas(_ sender: CustomSettingType) -> [String] {
        var data = [String]()
        switch sender {
        case .language:
            data = LanguageConfiguration.keys
        case .asset:
            data = CoinUnitConfiguration.values
        case .node:
            data = EOSBaseURLNodesConfiguration.values
        }
        return data
    }
    
    func selectedIndex(_ sender: CustomSettingType) -> Int {
        switch sender {
        case .language:
            let configuration = LanguageConfiguration()
            return configuration.indexWithValue(Defaults[.language])
        case .asset:
            return Defaults[.coinUnit]
        case .node:
            return Defaults[.currentURLNode]
        }
    }
    
    func setSelectIndex(_ sender: CustomSettingType, index: Int) {
        switch sender {
        case .language:
            if index > 0 {
                let configuration = LanguageConfiguration()
                let language = configuration.valueWithIndex(index)
                Defaults[.language] = language
                Localize.setCurrentLanguage(language)
            }
        case .asset:
            Defaults[.coinUnit] = index
        case .node:
            Defaults[.currentURLNode] = index
        }
    }
    
}
