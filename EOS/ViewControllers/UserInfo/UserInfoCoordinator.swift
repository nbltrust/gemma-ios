//
//  UserInfoCoordinator.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol UserInfoCoordinatorProtocol {
    func openNormalSetting()
    func openSafeSetting()
    func openHelpSetting()
    func openServersSetting()
    func openAboutSetting()
}

protocol UserInfoStateManagerProtocol {
    var state: UserInfoState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<UserInfoState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class UserInfoCoordinator: UserInfoRootCoordinator {
    
    lazy var creator = UserInfoPropertyActionCreate()
    
    var store = Store<UserInfoState>(
        reducer: UserInfoReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension UserInfoCoordinator: UserInfoCoordinatorProtocol {
    
    func openNormalSetting() {
        if let vc = R.storyboard.userInfo.normalViewController() {
            vc.coordinator = NormalCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    func openSafeSetting() {
        if let vc = R.storyboard.userInfo.safeViewController() {
            vc.coordinator = SafeCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    func openHelpSetting() {
        if let vc = R.storyboard.userInfo.helpViewController() {
            vc.coordinator = HelpCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    func openServersSetting() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.HELP_CN_URL
        vc.title = R.string.localizable.mine_server()
        self.rootVC.pushViewController(vc, animated: true)
    }
    func openAboutSetting() {
        if let vc = R.storyboard.userInfo.aboutViewController() {
            vc.coordinator = AboutCoordinator(rootVC: self.rootVC)
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
}

extension UserInfoCoordinator: UserInfoStateManagerProtocol {
    var state: UserInfoState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<UserInfoState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
