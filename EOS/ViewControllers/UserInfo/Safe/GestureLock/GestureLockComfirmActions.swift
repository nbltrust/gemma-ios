//
//  GestureLockComfirmActions.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

//MARK: - State
struct GestureLockComfirmState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: GestureLockComfirmPropertyState
    var callback: GestureLockConfirmCallbackState
}

struct GestureLockComfirmPropertyState {
    var reDrawFailedNum: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var promotData: BehaviorRelay<(message: String,isWarning: Bool,isLocked: Bool)> = BehaviorRelay(value: (R.string.localizable.ges_pas_current_pla.key.localized(),false,false))
    var locked: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

struct GestureLockConfirmCallbackState {
    var confirmResult: BehaviorRelay<ResultCallback?> = BehaviorRelay(value: nil)
}

struct SetConfirmPromotDataAction: Action {
    var data = ("", false, false)
}

struct SetGestureLockLockedAction: Action {
    var value = false
}

//MARK: - Action Creator
class GestureLockComfirmPropertyActionCreate {
    public typealias ActionCreator = (_ state: GestureLockComfirmState, _ store: Store<GestureLockComfirmState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: GestureLockComfirmState,
        _ store: Store <GestureLockComfirmState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
