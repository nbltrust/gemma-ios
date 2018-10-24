//
//  GestureLockSetActions.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

// MARK: - State
struct GestureLockSetState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: GestureLockSetPropertyState
    var callback: GestureLockSetCallbackState
}

struct GestureLockSetPropertyState {
    var reDrawFailedNum: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var password: BehaviorRelay<String> = BehaviorRelay(value: "")
    var promotData: BehaviorRelay<(message: String, isWarning: Bool)> = BehaviorRelay(value: (R.string.localizable.ges_pas_input_pla.key.localized(), false))
    var validedPassword: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

struct GestureLockSetCallbackState {
    var setResult: BehaviorRelay<ResultCallback?> = BehaviorRelay(value: nil)
}

struct SetPasswordAction: Action {
    var password = ""
}

struct SetValidedPasswordAction: Action {
    var valided = false
}

struct SetPromotDataAction: Action {
    var data = ("", false)
}

struct SetReDrawFailedNumAction: Action {
    var num = 0
}

// MARK: - Action Creator
class GestureLockSetPropertyActionCreate {
    public typealias ActionCreator = (_ state: GestureLockSetState, _ store: Store<GestureLockSetState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: GestureLockSetState,
        _ store: Store <GestureLockSetState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
