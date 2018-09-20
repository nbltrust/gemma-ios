//
//  ActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import Async

protocol ActivateCoordinatorProtocol {
    func pushToGetInviteCodeIntroductionVC()
}

protocol ActivateStateManagerProtocol {
    var state: ActivateState { get }
    
    func switchPageState(_ state:PageState)
    
    func pageVCs() -> [BaseViewController]
}

class ActivateCoordinator: EntryRootCoordinator {
    var store = Store(
        reducer: ActivateReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: ActivateState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(ActivateCoordinatorProtocol.self, observer: self)
        Broadcaster.register(ActivateStateManagerProtocol.self, observer: self)
    }
}

extension ActivateCoordinator: ActivateCoordinatorProtocol {
    func pushToGetInviteCodeIntroductionVC() {
        let vc = BaseWebViewController()
        vc.url = H5AddressConfiguration.GET_INVITECODE_URL
        vc.title = R.string.localizable.invitationcode_introduce.key.localized()
        self.rootVC.pushViewController(vc, animated: true)
    }
}

extension ActivateCoordinator: ActivateStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
    
    func pageVCs() -> [BaseViewController] {
        let payVC = R.storyboard.activate.payToActivateViewController()!
        let payCoor = PayToActivateCoordinator(rootVC: self.rootVC)
        payVC.coordinator = payCoor

        let friendVC = R.storyboard.activate.friendToActivateViewController()!
        let friendCoor = FriendToActivateCoordinator(rootVC: self.rootVC)
        friendVC.coordinator = friendCoor
        
        let exchangeVC = R.storyboard.activate.exchangeToActivateViewController()!
        let exchangeCoor = ExchangeToActivateCoordinator(rootVC: self.rootVC)
        exchangeVC.coordinator = exchangeCoor
        
        let invitationCodeVC = R.storyboard.activate.invitationCodeToActivateViewController()!
        let invitationCodeCoor = InvitationCodeToActivateCoordinator(rootVC: self.rootVC)
        invitationCodeVC.coordinator = invitationCodeCoor
        
        return [payVC,friendVC,exchangeVC,invitationCodeVC]
    }
}
