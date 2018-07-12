//
//  PaymentsReducers.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/10.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift

func PaymentsReducer(action:Action, state:PaymentsState?) -> PaymentsState {
    return PaymentsState(isLoading: loadingReducer(state?.isLoading, action: action), page: pageReducer(state?.page, action: action), errorMessage: errorMessageReducer(state?.errorMessage, action: action), property: PaymentsPropertyReducer(state?.property, action: action))
}

func PaymentsPropertyReducer(_ state: PaymentsPropertyState?, action: Action) -> PaymentsPropertyState {
    var state = state ?? PaymentsPropertyState()
    
    switch action {
    case let action as FetchPaymentsRecordsListAction:
        let mData : [PaymentsRecordsViewModel] = convertTransferViewModel(data: action.data)
        state.data = mData
    default:
        break
    }
    
    return state
}

func convertTransferViewModel(data:[Payment]) -> [PaymentsRecordsViewModel] {
    let dataArray: NSMutableArray = []
    
    for paymentData:Payment in data {
        var paymentsRecordsViewModel = PaymentsRecordsViewModel()
        if paymentData.to == WallketManager.shared.getAccount() {
            paymentsRecordsViewModel.stateImageName = "icIncome"
            paymentsRecordsViewModel.address = paymentData.from
            paymentsRecordsViewModel.money = "+\(paymentData.value)"
        } else {
            paymentsRecordsViewModel.stateImageName = "icSend"
            paymentsRecordsViewModel.address = paymentData.to
            paymentsRecordsViewModel.money = "-\(paymentData.value)"

        }
        paymentsRecordsViewModel.time = paymentData.time.dateString(ofStyle: DateFormatter.Style.full)
        if paymentData.status == PaymentStatus.unconfirmed {
            paymentsRecordsViewModel.transferState = "\(R.string.localizable.transfer_state_time)"
        }
        
        dataArray.add(paymentsRecordsViewModel)
        
        
    }
    return dataArray as! [PaymentsRecordsViewModel]

}

