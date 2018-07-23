//
//  AccountListActions.swift
//  EOS
//
//  Created zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct AccountListState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: AccountListPropertyState
}

struct AccountListPropertyState {
}

//MARK: - Action Creator
class AccountListPropertyActionCreate {
    public typealias ActionCreator = (_ state: AccountListState, _ store: Store<AccountListState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: AccountListState,
        _ store: Store <AccountListState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
