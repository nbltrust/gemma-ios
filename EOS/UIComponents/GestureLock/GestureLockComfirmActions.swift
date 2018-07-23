//
//  GestureLockComfirmActions.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct GestureLockComfirmState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: GestureLockComfirmPropertyState
}

struct GestureLockComfirmPropertyState {
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
