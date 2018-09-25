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

enum PageRefreshType: Int {
    case initial = 0
    case manual
    
    func mapReason() -> PageLoadReason {
        switch self {
        case .initial:
            return .initialRefresh
        case .manual:
            return .manualRefresh
        }
    }
}

enum PageLoadReason: Int {
    case initialRefresh = 0
    case manualRefresh
    case manualLoadMore
}

indirect enum PageState {
    case initial
    case loading(reason: PageLoadReason)
    case refresh(type: PageRefreshType)
    case loadMore(page: Int)
    case noMore
    case noData
    case normal(reason: PageLoadReason)
    case error(error: GemmaError, reason: PageLoadReason)
}

extension PageState: Equatable {
    static func == (lhs: PageState, rhs: PageState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.refresh(let lhsLast), .refresh(let rhsLast)):
            return lhsLast == rhsLast
        case (.loadMore(let lhsPage), .loadMore(let rhsPage)):
            return lhsPage == rhsPage
        case (.noMore, .noMore):
            return true
        case (.noData, .noData):
            return true
        case (.normal(let lhsLast), .normal(let rhsLast)):
            return lhsLast == rhsLast
        case (.error(let lhsError, _), .error(let rhsError, _)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

protocol BaseState: StateType {
    var pageState:BehaviorRelay<PageState> { get set }
    var context: BehaviorRelay<RouteContext?> { get set }
}

struct AppState:StateType {
    var property: AppPropertyState
}

struct AppPropertyState {
    
}

struct RouteContextAction: Action {
    var context: RouteContext?
}

struct PageStateAction: Action {
    var state: PageState
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
