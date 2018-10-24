//
//  NormalActions.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct NormalState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: NormalPropertyState
}

struct NormalPropertyState {
}

// MARK: - Action Creator
class NormalPropertyActionCreate {
    public typealias ActionCreator = (_ state: NormalState, _ store: Store<NormalState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: NormalState,
        _ store: Store <NormalState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
