//
//  WalletManagerActions.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct WalletManagerState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: WalletManagerPropertyState
}

struct WalletManagerPropertyState {
}

struct WalletManagerModel {
    var name = "-"
    var address = "-"
}

//MARK: - Action Creator
class WalletManagerPropertyActionCreate {
    public typealias ActionCreator = (_ state: WalletManagerState, _ store: Store<WalletManagerState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: WalletManagerState,
        _ store: Store <WalletManagerState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
