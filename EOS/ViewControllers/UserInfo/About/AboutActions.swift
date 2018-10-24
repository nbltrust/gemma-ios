//
//  AboutActions.swift
//  EOS
//
//  Created DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

// MARK: - State
struct AboutState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: AboutPropertyState
}

struct AboutPropertyState {
}

// MARK: - Action Creator
class AboutPropertyActionCreate {
    public typealias ActionCreator = (_ state: AboutState, _ store: Store<AboutState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: AboutState,
        _ store: Store <AboutState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
