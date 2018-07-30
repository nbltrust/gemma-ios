//
//  ResourceMortgageActions.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct ResourceMortgageState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: ResourceMortgagePropertyState
}

struct ResourceMortgagePropertyState {
}

//MARK: - Action Creator
class ResourceMortgagePropertyActionCreate {
    public typealias ActionCreator = (_ state: ResourceMortgageState, _ store: Store<ResourceMortgageState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: ResourceMortgageState,
        _ store: Store <ResourceMortgageState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
