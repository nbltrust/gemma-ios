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
        state.payments = action.data
        if state.lastPos == 1, state.data != nil, (state.data?.count)! > 0 {
            state.data!.removeAll()
        }
        let mData: [(String, [PaymentsRecordsViewModel])] = convertTransferViewModel(data: action.data, tupleArray: state.data)
        state.data = mData
    case let action as GetLastPosAction:
        if action.isRefresh == true {
            state.lastPos = 1
        } else {
            state.lastPos += 1
        }
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

func convertTransferViewModel(data: [Payment], tupleArray: [(String, [PaymentsRecordsViewModel])]?) -> [(String, [PaymentsRecordsViewModel])] {
    var newtupleArray = tupleArray
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
        let transferState = isSend ? "已发送" : "已接收"
        let money = isSend ? "-" + payment.quantity : "+" + payment.quantity

        var isContain = false
        if newtupleArray == nil || newtupleArray?.count == 0 {
            newtupleArray = [(time, [PaymentsRecordsViewModel(stateImageName: stateImage,
                                                              address: address,
                                                              time: time,
                                                              transferState: transferState,
                                                              money: money,
                                                              transferStateBool: state,
                                                              block: 0,
                                                              memo: payment.memo,
                                                              hashNumber: payment.trxId.hashNano,
                                                              hash: payment.trxId,
                                                              isSend: isSend)])]
            isContain = true
        } else {
            for index in 0..<newtupleArray!.count {
                let tuple = newtupleArray![index]
                if tuple.0 == time {
                    var newtuple = tuple
                    newtuple.1.append(PaymentsRecordsViewModel(stateImageName: stateImage,
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
                    newtupleArray!.remove(at: index)
                    newtupleArray!.insert(newtuple, at: index)
                    isContain = true
                    break
                }
            }
        }

        if isContain == false {
            newtupleArray!.append((time, [PaymentsRecordsViewModel(stateImageName: stateImage,
                                                                  address: address,
                                                                  time: time,
                                                                  transferState: transferState,
                                                                  money: money,
                                                                  transferStateBool: state,
                                                                  block: 0,
                                                                  memo: payment.memo,
                                                                  hashNumber: payment.trxId.hashNano,
                                                                  hash: payment.trxId,
                                                                  isSend: isSend)]))
        }
    }
    return newtupleArray!
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
