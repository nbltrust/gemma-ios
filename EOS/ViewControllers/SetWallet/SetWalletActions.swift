//
//  SetWalletActions.swift
//  EOS
//
//  Created DKM on 2018/7/20.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

// MARK: - State
struct SetWalletState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: SetWalletPropertyState
}

struct SetWalletPropertyState {
    var setWalletPasswordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var setWalletComfirmPasswordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var setWalletIsAgree: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

struct SetWalletPasswordAction: Action {
    var isValid: Bool = false
}

struct SetWalletComfirmPasswordAction: Action {
    var isValid: Bool = false
}

struct SetWalletAgreeAction: Action {
    var isAgree: Bool = false
}

// MARK: - Action Creator
class SetWalletPropertyActionCreate {
    public typealias ActionCreator = (_ state: SetWalletState, _ store: Store<SetWalletState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: SetWalletState,
        _ store: Store <SetWalletState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
