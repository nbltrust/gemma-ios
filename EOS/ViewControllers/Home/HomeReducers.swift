//
//  HomeReducers.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import CryptoSwift
import SwiftyUserDefaults

func gHomeReducer(action: Action, state: HomeState?) -> HomeState {
    return HomeState(isLoading: loadingReducer(state?.isLoading, action: action),
                     page: pageReducer(state?.page, action: action),
                     errorMessage: errorMessageReducer(state?.errorMessage, action: action),
                     property: gHomePropertyReducer(state?.property, action: action))
}

func gHomePropertyReducer(_ state: HomePropertyState?, action: Action) -> HomePropertyState {
    var state = state ?? HomePropertyState()

    switch action {
//    case let action as BalanceFetchedAction:

//        if action.balance != nil {
//            var viewmodel = state.info.value
//
//            if let balance = action.balance?.arrayValue.first?.string {
//                viewmodel.balance = balance
//            } else {
//                viewmodel.balance = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
//            }
//
//            viewmodel.allAssets = calculateTotalAsset(viewmodel)
//            viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
//            state.info.accept(viewmodel)
//        }
//        else {
//            let viewmodel = initAccountViewModel()
//            state.info.accept(viewmodel)
//        }
//    case let action as AccountFetchedAction:
//        if action.info != nil {
//            var viewmodel = convertAccountViewModelWithAccount(action.info!, viewmodel: state.info.value)
//            viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
//
//            state.info.accept(viewmodel)
//        }
//        else {
//            let viewmodel = initAccountViewModel()
//            state.info.accept(viewmodel)
//        }
//    case let action as RMBPriceFetchedAction:
//        if action.price != nil {
//            var viewmodel = state.info.value
//            state.cnyPrice = action.price!["value"].stringValue
//            if action.otherPrice != nil {
//                state.otherPrice = action.otherPrice!["value"].stringValue
//            }
//
//            viewmodel.CNY = calculateRMBPrice(viewmodel, price: state.cnyPrice, otherPrice: state.otherPrice)
//            state.info.accept(viewmodel)
//        }
//        else {
//            let viewmodel = initAccountViewModel()
//            state.info.accept(viewmodel)
//        }
//    case let action as AccountFetchedFromLocalAction:
//        if action.model != nil {
//            let viewmodel = convertToViewModelWithModel(model: action.model!)
////            viewmodel.CNY = calculateRMBPrice(viewmodel, price:state.CNY_price, otherPrice: state.Other_price)
//
//            state.model.accept(viewmodel)
//        } else {
//            let viewmodel = initAccountViewModel()
//            state.info.accept(viewmodel)
//        }
    default:
        break
    }

    return state
}

func initAccountViewModel() -> AccountViewModel {
    var newViewModel = AccountViewModel()
    newViewModel.account = "--"
    newViewModel.portrait = ""
    newViewModel.cpuValue = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    newViewModel.netValue = "- \(NetworkConfiguration.EOSIODefaultSymbol)"

    newViewModel.cpuProgress = 0
    newViewModel.netProgress = 0
    newViewModel.ramProgress = 0

    newViewModel.ramValue = "- \(NetworkConfiguration.EOSIODefaultSymbol)"

    newViewModel.recentRefundAsset = "- \(NetworkConfiguration.EOSIODefaultSymbol)"

    newViewModel.refundTime = ""

    newViewModel.allAssets = calculateTotalAsset(newViewModel)

    return newViewModel
}

func convertAccountViewModelWithAccount(_ account: Account, viewmodel: AccountViewModel) -> AccountViewModel {
    var newViewModel = viewmodel
    newViewModel.account = account.accountName
    newViewModel.portrait = account.accountName.sha256()
    newViewModel.cpuValue = account.selfDelegatedBandwidth?.cpuWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    newViewModel.netValue = account.selfDelegatedBandwidth?.netWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"

    if let used = account.cpuLimit?.used.string, let max = account.cpuLimit?.max.string {
        newViewModel.cpuProgress = used.float()! / max.float()!
    }
    if let used = account.netLimit?.used.string, let max = account.netLimit?.max.string {
        newViewModel.netProgress = used.float()! / max.float()!
    }
    newViewModel.ramProgress = Float(account.ramUsage) / Float(account.ramQuota)

    if let ram = account.totalResources?.ramBytes {
        newViewModel.ramValue = ram.ramCount
    } else {
        newViewModel.ramValue = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    }

    if let refundNet = account.refundRequest?.netAmount.eosAmount.toDouble(), let refundCpu = account.refundRequest?.cpuAmount.eosAmount.toDouble() {
        let asset = refundCpu + refundNet
        newViewModel.recentRefundAsset = "\(asset.string(digits: AppConfiguration.EOSPrecision)) \(NetworkConfiguration.EOSIODefaultSymbol)"
    } else {
        newViewModel.recentRefundAsset = "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    }

    if let date = account.refundRequest?.requestTime {
        newViewModel.refundTime = date.refundStatus
    } else {
        newViewModel.refundTime = ""
    }

    newViewModel.allAssets = calculateTotalAsset(newViewModel)

    return newViewModel
}

func calculateTotalAsset(_ viewmodel: AccountViewModel) -> String {
    if let balance = viewmodel.balance.eosAmount.toDouble(), let cpu = viewmodel.cpuValue.eosAmount.toDouble(),
        let net = viewmodel.netValue.eosAmount.toDouble() {
        let total = balance + cpu + net

        return total.string(digits: AppConfiguration.EOSPrecision) + " \(NetworkConfiguration.EOSIODefaultSymbol)"
    } else {
        return "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    }
}

func calculateRMBPrice(_ viewmodel: AccountViewModel, price: String, otherPrice: String) -> String {
    if let unit = price.toDouble(), unit != 0, let all = viewmodel.allAssets.eosAmount.toDouble(), all != 0 {
        let cny = unit * all
        if coinType() == .CNY {
            return "≈" + cny.string(digits: 2) + " \(coinUnit())"
        } else {
            if let otherPriceDouble = otherPrice.toDouble() {
                return "≈" + (cny / otherPriceDouble).string(digits: 2) + " \(coinUnit())"
            } else {
                return "≈- \(coinUnit())"
            }
        }
    } else {
        return "≈- \(coinUnit())"
    }
}

func convertToViewModelWithModel(model: AccountModel) -> AccountViewModel {
    var viewModel = AccountViewModel()
    viewModel.account = model.accountName
    viewModel.portrait = model.accountName.sha256()
    viewModel.cpuValue = model.delegateCpuWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    viewModel.netValue = model.delegateNetWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"
    viewModel.ramValue = model.ramBytes != nil ? model.ramBytes.ramCount : ""
    viewModel.cpuProgress = Float(model.cpuUsed) / Float(model.cpuMax)
    viewModel.netProgress = Float(model.netUsed) / Float(model.netMax)
    viewModel.ramProgress = Float(model.ramUsage) / Float(model.ramQuota)
    if let balance = Defaults[model.accountName + NetworkConfiguration.BlanceDefaultSymbol] as? String {
        viewModel.balance = balance
    }
    viewModel.allAssets = calculateTotalAsset(viewModel)
    if let rmbUnit = Defaults[Unit.RMBUnit] as? String, let usdUnit = Defaults[Unit.USDUnit] as? String {
        viewModel.CNY = calculateRMBPrice(viewModel, price: rmbUnit, otherPrice: usdUnit)
    }

    return viewModel
}
