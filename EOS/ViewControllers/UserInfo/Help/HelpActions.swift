//
//  HelpActions.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct HelpState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: HelpPropertyState
}

struct HelpPropertyState {
}

// MARK: - Action Creator
class HelpPropertyActionCreate {
    public typealias ActionCreator = (_ state: HelpState, _ store: Store<HelpState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: HelpState,
        _ store: Store <HelpState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
