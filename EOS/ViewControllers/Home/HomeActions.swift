//
//  HomeActions.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State
struct HomeState: StateType {
    var isLoading = false
    var page: Int = 1
    var errorMessage:String?
    var property: HomePropertyState
}

struct HomePropertyState {
}

//MARK: - Action Creator
class HomePropertyActionCreate {
    public typealias ActionCreator = (_ state: HomeState, _ store: Store<HomeState>) -> Action?
    
    public typealias AsyncActionCreator = (
        _ state: HomeState,
        _ store: Store <HomeState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
}
