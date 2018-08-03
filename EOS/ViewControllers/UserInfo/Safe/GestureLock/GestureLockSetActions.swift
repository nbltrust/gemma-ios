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

//MARK: - State
struct GestureLockSetState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: GestureLockSetPropertyState
}

struct GestureLockSetPropertyState {
    var password: BehaviorRelay<String> = BehaviorRelay(value: "")
    var validedPassword: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

struct SetPasswordAction {
    var password: String?
}


//MARK: - Action Creator
class GestureLockSetPropertyActionCreate {
    public typealias ActionCreator = (_ state: GestureLockSetState, _ store: Store<GestureLockSetState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: GestureLockSetState,
        _ store: Store <GestureLockSetState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
