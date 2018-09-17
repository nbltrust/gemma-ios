//
//  BLTCardEntryCoordinator.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter
import Presentr

protocol BLTCardEntryCoordinatorProtocol {
    func pushIntroduceVC()
    
    func presentBLTCardSearchVC()
}

protocol BLTCardEntryStateManagerProtocol {
    var state: BLTCardEntryState { get }
    
    func switchPageState(_ state:PageState)
}

class BLTCardEntryCoordinator: BLTCardRootCoordinator {
    var store = Store(
        reducer: BLTCardEntryReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: BLTCardEntryState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(BLTCardEntryCoordinatorProtocol.self, observer: self)
        Broadcaster.register(BLTCardEntryStateManagerProtocol.self, observer: self)
    }
}

extension BLTCardEntryCoordinator: BLTCardEntryCoordinatorProtocol {
    func pushIntroduceVC() {
        
    }
    
    func presentBLTCardSearchVC() {
        let width = ModalSize.full
        
        let height:Float = 320
        let heightSize = ModalSize.custom(size: height)
        
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height - height.cgFloat))
        let customType = PresentationType.custom(width: width, height: heightSize, center: center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.keyboardTranslationType = .stickToTop
        
        let newVC = BaseNavigationController()
        newVC.navStyle = .white
        let bltCard = BLTCardRootCoordinator(rootVC: newVC)
        
        
        if let vc = R.storyboard.bltCard.bltCardSearchViewController() {
            let coordinator = BLTCardSearchCoordinator(rootVC: bltCard.rootVC)
            vc.coordinator = coordinator
            bltCard.rootVC.pushViewController(vc, animated: true)
            
            self.rootVC.topViewController?.customPresentViewController(presenter, viewController: newVC, animated: true, completion: nil)
        }
    }
}

extension BLTCardEntryCoordinator: BLTCardEntryStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        self.store.dispatch(PageStateAction(state: state))
    }
}
