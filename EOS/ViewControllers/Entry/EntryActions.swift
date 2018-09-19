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
    
    var passwordValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var comfirmPasswordValid : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var inviteCodeValid : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var isAgree: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var validation: BehaviorRelay<WookongValidation> = BehaviorRelay(value: WookongValidation())
    
    var checkSeedSuccessed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var getSNSuccessed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var getPubKeySuccessed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

struct EntryCallbackState {
    var endCallback: BehaviorRelay<CompletionCallback?> = BehaviorRelay(value: nil)
}

struct nameAction: Action {
    var isValid: Bool = false
}

struct passwordAction: Action {
    var isValid: Bool = false
}

struct comfirmPasswordAction: Action {
    var isValid: Bool = false
}

struct agreeAction: Action {
    var isAgree: Bool = false
}

struct SetValidationAction: Action {
    var validation: WookongValidation?
}

struct SetCheckSeedSuccessedAction: Action {
    var isCheck: Bool = false
}

struct SetSNSuccessedAction: Action {
    var isSuccessed: Bool = false
}

struct SetPubkeySuccessedAction: Action {
    var isSuccessed: Bool = false
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
