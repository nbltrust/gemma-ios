//
//  FingerCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule

protocol FingerCoordinatorProtocol {
    func pushToManagerFingerVC(model: WalletManagerModel, index: Int)

    func pushToENtroFingerVC()
    
    func pushToUpdatePinVC()
}

protocol FingerStateManagerProtocol {
    var state: FingerState { get }

    func switchPageState(_ state: PageState)

    func getFPList(_ success: @escaping GetFPListComplication, failed: @escaping FailedComplication)
    
    func changePin()
}

class FingerCoordinator: NavCoordinator {
    var store = Store(
        reducer: FingerReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: FingerState {
        return store.state
    }

    override class func start(_ root: BaseNavigationController, context: RouteContext? = nil) -> BaseViewController {
        let vc = R.storyboard.wallet.fingerViewController()!
        let coordinator = FingerCoordinator(rootVC: root)
        vc.coordinator = coordinator
        coordinator.store.dispatch(RouteContextAction(context: context))
        return vc
    }

    override func register() {
        Broadcaster.register(FingerCoordinatorProtocol.self, observer: self)
        Broadcaster.register(FingerStateManagerProtocol.self, observer: self)
    }
}

extension FingerCoordinator: FingerCoordinatorProtocol {
    func pushToENtroFingerVC() {
        let fingerVC = R.storyboard.bltCard.bltCardSetFingerPrinterViewController()!
        let coor = BLTCardSetFingerPrinterCoordinator(rootVC: self.rootVC)
        fingerVC.coordinator = coor
        self.rootVC.pushViewController(fingerVC, animated: true)
    }

    func pushToManagerFingerVC(model: WalletManagerModel, index: Int) {
        if let vc = R.storyboard.wallet.deleteFingerViewController() {
            let coordinator = DeleteFingerCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.model = model
            vc.index = index
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func pushToUpdatePinVC() {
        if let vc = R.storyboard.leadIn.setWalletViewController() {
            vc.coordinator = SetWalletCoordinator(rootVC: self.rootVC)
            vc.settingType = .updatePin
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension FingerCoordinator: FingerStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func getFPList(_ success: @escaping GetFPListComplication, failed: @escaping FailedComplication) {
        BLTWalletIO.shareInstance()?.getFPList(success, failed: failed)
    }
    
    func changePin() {
        confirmPin { [weak self] in
            guard let `self` = self else { return }
            self.pushToUpdatePinVC()
        }
    }
}
