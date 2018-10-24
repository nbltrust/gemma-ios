//
//  FingerPrinterConfirmActions.swift
//  EOS
//
//  Created peng zhu on 2018/8/3.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

// MARK: - State
struct FingerPrinterConfirmState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage: String?
    var property: FingerPrinterConfirmPropertyState
    var callback: FingerPrinterConfirmCallbackState
}

struct FingerPrinterConfirmPropertyState {
}

struct FingerPrinterConfirmCallbackState {
    var confirmResult: BehaviorRelay<ResultCallback?> = BehaviorRelay(value: nil)
}

// MARK: - Action Creator
class FingerPrinterConfirmPropertyActionCreate {
    public typealias ActionCreator = (_ state: FingerPrinterConfirmState, _ store: Store<FingerPrinterConfirmState>) -> Action?

    public typealias AsyncActionCreator = (
        _ state: FingerPrinterConfirmState,
        _ store: Store <FingerPrinterConfirmState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
