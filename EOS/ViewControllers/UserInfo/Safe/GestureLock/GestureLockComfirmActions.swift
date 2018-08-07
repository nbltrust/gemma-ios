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
    var promotData: BehaviorRelay<(message: String,isWarning: Bool)> = BehaviorRelay(value: (R.string.localizable.ges_pas_current_pla(),false))
}

struct GestureLockConfirmCallbackState {
    var confirmResult: BehaviorRelay<ResultCallback?> = BehaviorRelay(value: nil)
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
