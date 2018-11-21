//
//  EntryActions.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

//MARK: - State
struct EntryState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: EntryPropertyState
    var callback: EntryCallbackState
}

struct EntryPropertyState {
    var nameValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var walletNameValid: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var passwordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var comfirmPasswordValid : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var inviteCodeValid : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isAgree: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var checkSeedSuccessed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var model: WalletModel? = nil
}

struct EntryCallbackState {
    var endCallback: BehaviorRelay<CompletionCallback?> = BehaviorRelay(value: nil)
    
    var finishBLTWalletCallback: BehaviorRelay<CompletionCallback?> = BehaviorRelay(value: nil)
    var finishNormalWalletCallback: BehaviorRelay<ObjectCallback?> = BehaviorRelay(value: nil)
    var finishEOSCurrencyCallback: BehaviorRelay<ObjectCallback?> = BehaviorRelay(value: nil)
}

struct NameAction: Action {
    var isValid: Bool = false
}

struct WalletNameAction: Action {
    var isValid: Bool = false
}

struct PasswordAction: Action {
    var isValid: Bool = false
}

struct ComfirmPasswordAction: Action {
    var isValid: Bool = false
}

struct AgreeAction: Action {
    var isAgree: Bool = false
}

struct SetCheckSeedSuccessedAction: Action {
    var isCheck: Bool = false
}

struct WalletModelAction: Action {
    var model: WalletModel?
}

struct WalletModel {
    var pwd: String
    var prompt: String
    var type: WalletType
}

//MARK: - Action Creator
class EntryPropertyActionCreate {
    public typealias ActionCreator = (_ state: EntryState, _ store: Store<EntryState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: EntryState,
        _ store: Store <EntryState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
