//
//  LeadInActions.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

// MARK: - State
struct LeadInState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: LeadInPropertyState
    var callback: LeadInCallbackState
}

struct LeadInPropertyState {
}

struct LeadInCallbackState {
    var fadeCallback: BehaviorRelay<CompletionCallback?> = BehaviorRelay(value: nil)
}

// MARK: - Action Creator
class LeadInPropertyActionCreate {
    public typealias ActionCreator = (_ state: LeadInState, _ store: Store<LeadInState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: LeadInState,
        _ store: Store <LeadInState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
