//
//  InvitationCodeToActivateCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import SwiftNotificationCenter
import Async

protocol InvitationCodeToActivateCoordinatorProtocol {
}

protocol InvitationCodeToActivateStateManagerProtocol {
    var state: InvitationCodeToActivateState { get }
    
    func switchPageState(_ state:PageState)
}

class InvitationCodeToActivateCoordinator: HomeRootCoordinator {
    var store = Store(
        reducer: InvitationCodeToActivateReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
    
    var state: InvitationCodeToActivateState {
        return store.state
    }
            
    override func register() {
        Broadcaster.register(InvitationCodeToActivateCoordinatorProtocol.self, observer: self)
        Broadcaster.register(InvitationCodeToActivateStateManagerProtocol.self, observer: self)
    }
}

extension InvitationCodeToActivateCoordinator: InvitationCodeToActivateCoordinatorProtocol {
    
}

extension InvitationCodeToActivateCoordinator: InvitationCodeToActivateStateManagerProtocol {
    func switchPageState(_ state:PageState) {
        Async.main {
            self.store.dispatch(PageStateAction(state: state))
        }
    }
}
