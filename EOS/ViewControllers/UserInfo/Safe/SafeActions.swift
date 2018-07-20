//
//  SafeActions.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct SafeState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: SafePropertyState
}

struct SafePropertyState {
}

//MARK: - Action Creator
class SafePropertyActionCreate {
    public typealias ActionCreator = (_ state: SafeState, _ store: Store<SafeState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: SafeState,
        _ store: Store <SafeState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
