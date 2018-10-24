//
//  CreatationCompleteActions.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct CreatationCompleteState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: CreatationCompletePropertyState
}

struct CreatationCompletePropertyState {
}

// MARK: - Action Creator
class CreatationCompletePropertyActionCreate {
    public typealias ActionCreator = (_ state: CreatationCompleteState, _ store: Store<CreatationCompleteState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: CreatationCompleteState,
        _ store: Store <CreatationCompleteState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
