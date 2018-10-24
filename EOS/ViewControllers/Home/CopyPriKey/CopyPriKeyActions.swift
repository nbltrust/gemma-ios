//
//  CopyPriKeyActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct CopyPriKeyState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: CopyPriKeyPropertyState
}

struct CopyPriKeyPropertyState {
}

// MARK: - Action Creator
class CopyPriKeyPropertyActionCreate {
    public typealias ActionCreator = (_ state: CopyPriKeyState, _ store: Store<CopyPriKeyState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: CopyPriKeyState,
        _ store: Store <CopyPriKeyState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
