//
//  WalletActions.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct WalletState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: WalletPropertyState
}

struct WalletPropertyState {
}

// MARK: - Action Creator
class WalletPropertyActionCreate {
    public typealias ActionCreator = (_ state: WalletState, _ store: Store<WalletState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: WalletState,
        _ store: Store <WalletState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
