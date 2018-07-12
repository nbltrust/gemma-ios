//
//  TransferConfirmCoordinator.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

protocol TransferConfirmCoordinatorProtocol {
    func pushToTransferConfirmPwdVC()
    func dismissConfirmVC()
}

protocol TransferConfirmStateManagerProtocol {
    var state: TransferConfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class TransferConfirmCoordinator: TransferRootCoordinator {
    
    lazy var creator = TransferConfirmPropertyActionCreate()
    
    var store = Store<TransferConfirmState>(
        reducer: TransferConfirmReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension TransferConfirmCoordinator: TransferConfirmCoordinatorProtocol {
    func pushToTransferConfirmPwdVC() {
//        let width = ModalSize.full
//        let height = ModalSize.custom(size: 369)
//        let center = ModalCenterPosition.bottomCenter
//        let customType = PresentationType.custom(width: width, height: height, center: center)
//        
//        let presenter = Presentr(presentationType: customType)
        
        guard let transferConfirmPwdVC = self.rootVC.topViewController as? TransferConfirmViewController else { return }
        
        let vc = R.storyboard.transfer.transferConfirmPasswordViewController()
        let coordinator = TransferConfirmPasswordCoordinator(rootVC: self.rootVC)
        vc?.coordinator = coordinator
        self.rootVC.pushViewController(vc!, animated: true)
    }
    
    func dismissConfirmVC() {
        self.rootVC.dismiss(animated: true, completion: nil)
    }

}

extension TransferConfirmCoordinator: TransferConfirmStateManagerProtocol {
    var state: TransferConfirmState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
}
