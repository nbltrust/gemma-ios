//
//  PaymentsDetailCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol PaymentsDetailCoordinatorProtocol {
    func openWebView()
}

protocol PaymentsDetailStateManagerProtocol {
    var state: PaymentsDetailState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsDetailState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class PaymentsDetailCoordinator: HomeRootCoordinator {
    
    lazy var creator = PaymentsDetailPropertyActionCreate()
    
    var store = Store<PaymentsDetailState>(
        reducer: PaymentsDetailReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension PaymentsDetailCoordinator: PaymentsDetailCoordinatorProtocol {
    func openWebView() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.GET_INVITECODE_URL
        vc.title = R.string.localizable.invitationcode_introduce.key.localized()
        self.rootVC.pushViewController(vc, animated: true)
    }
}

extension PaymentsDetailCoordinator: PaymentsDetailStateManagerProtocol {
    var state: PaymentsDetailState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<PaymentsDetailState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
