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
    func pushToTransferConfirmPwdVC(toAccount:String,money:String,remark:String,type:String)
    func dismissConfirmVC()
}

protocol TransferConfirmStateManagerProtocol {
    var state: TransferConfirmState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<TransferConfirmState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
}

class TransferConfirmCoordinator: NavCoordinator {
    
    lazy var creator = TransferConfirmPropertyActionCreate()
    
    var store = Store<TransferConfirmState>(
        reducer: TransferConfirmReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    override class func start(_ root: BaseNavigationController) -> BaseViewController {
        let vc = R.storyboard.transfer.transferConfirmViewController()!
        let coordinator = TransferConfirmCoordinator(rootVC: root)
        vc.coordinator = coordinator
        return vc
    }
}

extension TransferConfirmCoordinator: TransferConfirmCoordinatorProtocol {
    func pushToTransferConfirmPwdVC(toAccount:String,money:String,remark:String,type:String) {
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
        vc?.receiver = toAccount
        vc?.amount = money
        vc?.remark = remark
        vc?.type = type
        vc?.iconType = leftIconType.pop.rawValue
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
