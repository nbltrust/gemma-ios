//
//  TransferActions.swift
//  EOS
//
//  Created DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa

//MARK: - State
struct TransferState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: TransferPropertyState
}

struct TransferPropertyState {
    var balance : BehaviorRelay<String?> = BehaviorRelay(value: nil)
}



//MARK: - Action Creator
class TransferPropertyActionCreate {
    public typealias ActionCreator = (_ state: TransferState, _ store: Store<TransferState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: TransferState,
        _ store: Store <TransferState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
