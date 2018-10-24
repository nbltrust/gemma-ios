//
//  ChangeWalletNameActions.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct ChangeWalletNameState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: ChangeWalletNamePropertyState
}

struct ChangeWalletNamePropertyState {
}

// MARK: - Action Creator
class ChangeWalletNamePropertyActionCreate {
    public typealias ActionCreator = (_ state: ChangeWalletNameState, _ store: Store<ChangeWalletNameState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: ChangeWalletNameState,
        _ store: Store <ChangeWalletNameState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
