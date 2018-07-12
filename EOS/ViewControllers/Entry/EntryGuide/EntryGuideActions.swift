//
//  EntryGuideActions.swift
//  EOS
//
//  Created peng zhu on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct EntryGuideState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: EntryGuidePropertyState
}

struct EntryGuidePropertyState {
}

//MARK: - Action Creator
class EntryGuidePropertyActionCreate {
    public typealias ActionCreator = (_ state: EntryGuideState, _ store: Store<EntryGuideState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: EntryGuideState,
        _ store: Store <EntryGuideState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
