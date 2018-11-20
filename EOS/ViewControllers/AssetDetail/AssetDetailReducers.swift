//
//  AssetDetailReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func gAssetDetailReducer(action:Action, state:AssetDetailState?) -> AssetDetailState {
    var state = state ?? AssetDetailState()
        
    switch action {
    case let action as FetchPaymentsRecordsListAction:
        state.data.removeAll()
        state.payments = action.data
        let mData: [String: [PaymentsRecordsViewModel]] = convertTransferViewModel(data: action.data, dict: state.data)
        state.data = mData
    case let action as GetLastPosAction:
        state.lastPos = action.lastPos
    case _ as RemoveAction:
        state.data.removeAll()
    case let action as MBalanceFetchedAction:
        var viewmodel = state.info.value
            if let balance = action.balance.arrayValue.first?.string {
                viewmodel.balance = balance.components(separatedBy: " ")[0]
            } else {
                viewmodel.balance = "0.0000"
        }
        viewmodel.name = "EOS"
        viewmodel.contract = EOSIOContract.TokenCode
        viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
        state.info.accept(viewmodel)
    case _ as RMBPriceFetchedAction:
        var viewmodel = state.info.value
        if coinType() == .CNY, let eos = CurrencyManager.shared.getCNYPrice() {
            state.cnyPrice = eos
        } else if coinType() == .USD, let usd = CurrencyManager.shared.getUSDPrice() {
            state.otherPrice = usd
        }
        viewmodel.name = "EOS"
        viewmodel.contract = EOSIOContract.TokenCode
        viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
        state.info.accept(viewmodel)
    case let action as ATokensFetchedAction:
        if let model = convertViewModelWithTokens(tokensJson: action.data, symbol: action.symbol) {
            state.info.accept(model)
        }
    default:
        break
    }
        
    return state
}

func convertTransferViewModel(data: [Payment], dict: [String: [PaymentsRecordsViewModel]]) -> [String: [PaymentsRecordsViewModel]] {
    var newdict = dict
    var modelArray: [PaymentsRecordsViewModel] = []
    for payment in data {
        let isSend: Bool = payment.sender == CurrencyManager.shared.getCurrentAccountName()
        let state: Bool = true//payment.status.rawValue == 3
        let stateImage: UIImage? = isSend ? R.image.icTabPay() : R.image.icTabIncomeDeepBlue()

        var receiver = ""
        var sender = ""
        if payment.receiver != nil {
            receiver = payment.receiver
        }
        if payment.sender != nil {
            sender = payment.sender
        }
        let address = isSend ? receiver : sender
        let time = payment.timestamp.string(withFormat: "MM-dd yyyy")
        let transferState = "已接收"
        let money = isSend ? "-" + payment.quantity : "+" + payment.quantity

        if newdict.keys.contains(time) {
            modelArray = newdict[time]!
        } else {
            modelArray = []
        }
        modelArray.append(PaymentsRecordsViewModel(stateImageName: stateImage,
                                                   address: address,
                                                   time: time,
                                                   transferState: transferState,
                                                   money: money,
                                                   transferStateBool: state,
                                                   block: 0,
                                                   memo: payment.memo,
                                                   hashNumber: payment.trxId.hashNano,
                                                   hash: payment.trxId,
                                                   isSend: isSend))
        newdict[time] = modelArray
    }
    return newdict
}

func calculateRMBPrice(_ viewmodel: AssetViewModel, price: String, otherPrice: String) -> String {
    if let unit = price.toDecimal(), unit != 0, let all = viewmodel.balance.toDecimal(), all != 0 {
        let cny = unit * all
        if coinType() == .CNY {
            return cny.formatCurrency(digitNum: 2)
        } else {
            if let otherPriceDouble = otherPrice.toDecimal() {
                return (cny / otherPriceDouble).formatCurrency(digitNum: 2)
            } else {
                return "0.00"
            }
        }
    } else {
        return "0.00"
    }
}

func convertViewModelWithTokens(tokensJson: [Tokens], symbol: String) -> AssetViewModel? {
    for token in tokensJson {
        if token.symbol == symbol {
            var model = AssetViewModel()
            model.name = token.symbol
            model.iconUrl = token.logoUrl
            model.balance = token.balance
            model.contract = token.code
            return model
        }
    }
    return nil
}
