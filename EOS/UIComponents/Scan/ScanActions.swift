//
//  ScanActions.swift
//  EOS
//
//  Created peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct ScanState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: ScanPropertyState
}

struct ScanPropertyState {
}

//MARK: - Action Creator
class ScanPropertyActionCreate {
    public typealias ActionCreator = (_ state: ScanState, _ store: Store<ScanState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: ScanState,
        _ store: Store <ScanState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
