//
//  AppReducer.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import ReSwift

func AppReducer(action:Action, state:AppState?) -> AppState {
    return AppState(property: AppPropertyReducer(state?.property, action: action))
}

func AppPropertyReducer(_ state: AppPropertyState?, action: Action) -> AppPropertyState {
    var state = state ?? AppPropertyState()

    switch action {
        
    default:
        break
    }
    
    return state
}


func loadingReducer(_ state: Bool?, action: Action) -> Bool {
    var state = state ?? false
    
    switch action {
    case _ as StartLoading:
        state = true
    case _ as EndLoading:
        state = false
    default:
        break
    }
    
    return state
}

func errorMessageReducer(_ state: String?, action: Action) -> String {
    var state = state ?? ""
    
    switch action {
    case let action as NetworkErrorMessage:
        state = action.errorMessage
    case _ as CleanErrorMessage:
        state = ""
    default:
        break
    }
    
    return state
}

func pageReducer(_ state: Int?, action: Action) -> Int {
    var state = state ?? 1
    
    switch action {
    case _ as NextPage:
        state = state + 1
    case _ as ResetPage:
        state = 1
    default:
        break
    }
    
    return state
}

public class BlockSubscriber<S>: StoreSubscriber {
    public typealias StoreSubscriberStateType = S
    private let block: (S) -> Void
    
    public init(block: @escaping (S) -> Void) {
        self.block = block
    }
    
    public func newState(state: S) {
        self.block(state)
    }
}

let TrackingMiddleware: Middleware<Any> = { dispatch, getState in
    return { next in
        return { action in
            if let action = action as? PageStateAction, let state = getState() as? BaseState {
                state.pageState.accept(action.state)
            }
            else if let action = action as? RefreshState {
                _ = action.vc?.perform(action.sel)
            }
            
            return next(action)
        }
    }
}
