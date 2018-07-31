//
//  ResourceMortgageReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func ResourceMortgageReducer(action:Action, state:ResourceMortgageState?) -> ResourceMortgageState {
    return ResourceMortgageState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: ResourceMortgagePropertyReducer(state?.property, action: action))
}

func ResourceMortgagePropertyReducer(_ state: ResourceMortgagePropertyState?, action: Action) -> ResourceMortgagePropertyState {
    var state = state ?? ResourceMortgagePropertyState()
    
    switch action {
    default:
        break
    }
    
    return state
}



