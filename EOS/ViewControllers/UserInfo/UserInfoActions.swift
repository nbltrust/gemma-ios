//
//  UserInfoActions.swift
//  EOS
//
//  Created koofrank on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct UserInfoState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: UserInfoPropertyState
}

struct UserInfoPropertyState {
}

// MARK: - Action Creator
class UserInfoPropertyActionCreate {
    public typealias ActionCreator = (_ state: UserInfoState, _ store: Store<UserInfoState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: UserInfoState,
        _ store: Store <UserInfoState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
