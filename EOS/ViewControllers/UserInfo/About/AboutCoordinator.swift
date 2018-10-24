//
//  AboutCoordinator.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol AboutCoordinatorProtocol {
    func openReleaseNotes()
}

protocol AboutStateManagerProtocol {
    var state: AboutState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<AboutState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class AboutCoordinator: NavCoordinator {

    lazy var creator = AboutPropertyActionCreate()

    var store = Store<AboutState>(
        reducer: AboutReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )
}

extension AboutCoordinator: AboutCoordinatorProtocol {
    func openReleaseNotes() {
        let vc = BaseWebViewController()
        let language = getCurrentLanguage()
        if language == "en" {
            vc.url = H5AddressConfiguration.RELEASE_NOTES_EN_URL
        } else if language == "cn" {
            vc.url = H5AddressConfiguration.RELEASE_NOTES_CN_URL
        } else {
            vc.url = H5AddressConfiguration.RELEASE_NOTES_EN_URL
        }
        vc.title = R.string.localizable.about_info.key.localized()
        self.rootVC.pushViewController(vc, animated: true)
    }
}

extension AboutCoordinator: AboutStateManagerProtocol {
    var state: AboutState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<AboutState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

}
