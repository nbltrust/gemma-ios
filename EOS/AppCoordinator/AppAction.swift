//
//  AppAction.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift
import RxCocoa

enum PageState {
    case initial
    case loading
    case refreshing
    case loadMore
    case noMore
    case noData
    case normal
    case error(Error)
}

protocol BaseState: StateType {
    var pageState:BehaviorRelay<PageState> { get set }
}

struct AppState:StateType {
    var property: AppPropertyState
}

struct AppPropertyState {
    
}

struct StartLoading: Action {
    var vc: BaseViewController?
}
struct EndLoading: Action {
    var vc: BaseViewController?
}

struct RefreshState:Action {
    let sel:Selector
    let vc:BaseViewController?
}

struct NetworkErrorMessage: Action {
    let errorMessage:String
}
struct CleanErrorMessage: Action {}

struct NextPage: Action {}

struct ResetPage: Action {}
