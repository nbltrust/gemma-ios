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
    var callback: SetWalletCallbackState
}

struct ImportWalletModel {
    var walletType: WalletType = .HD
    var name = ""
    var priKey = ""
    var type: CurrencyType = .EOS
    var password = ""
    var hint = ""
    var mnemonic = ""

    public init(walletType: WalletType,
                name: String,
                priKey: String,
                type: CurrencyType,
                password: String,
                hint: String,
                mnemonic: String) {
        self.walletType = walletType
        self.name = name
        self.type = type
        self.priKey = priKey
        self.password = password
        self.hint = hint
        self.mnemonic = mnemonic
    }
}

struct SetWalletCallbackState {
}

struct SetWalletPropertyState {
    var setWalletNameValid: BehaviorRelay<Bool> = BehaviorRelay(value: true)

    var setWalletPasswordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var setWalletComfirmPasswordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var setWalletIsAgree: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    var setWalletOriginalPasswordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

struct SetWalletNameAction: Action {
    var isValid: Bool = false
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

struct SetWalletOriginalPasswordAction: Action {
    var isValid: Bool = false
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
