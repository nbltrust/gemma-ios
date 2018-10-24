//
//  FaceIDComfirmCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol FaceIDComfirmCoordinatorProtocol {
    func dismiss()
}

protocol FaceIDComfirmStateManagerProtocol {
    var state: FaceIDComfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<FaceIDComfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState

    func confirm()
}

class FaceIDComfirmCoordinator: NavCoordinator {

    lazy var creator = FaceIDComfirmPropertyActionCreate()

    var store = Store<FaceIDComfirmState>(
        reducer: FaceIDComfirmReducer,
        state: nil,
        middleware: [TrackingMiddleware]
    )
}

extension FaceIDComfirmCoordinator: FaceIDComfirmCoordinatorProtocol {
    func dismiss() {
        self.rootVC.dismiss(animated: true) {
            self.state.callback.confirmResult.value?(false)
        }
    }
}

extension FaceIDComfirmCoordinator: FaceIDComfirmStateManagerProtocol {
    var state: FaceIDComfirmState {
        return store.state
    }

    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<FaceIDComfirmState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }

    func confirm() {
        SafeManager.shared.confirmFaceIdLock(R.string.localizable.fingerid_reason.key.localized()) {[weak self] (result) in
            guard let `self` = self else { return }
            if result {
                self.rootVC.dismiss(animated: true) {
                    self.state.callback.confirmResult.value?(true)
                }
            }
        }
    }

}
