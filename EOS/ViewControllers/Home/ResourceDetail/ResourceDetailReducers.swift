//
//  ResourceDetailReducers.swift
//  EOS
//
//  Created zhusongyu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift

func gResourceDetailReducer(action:Action, state:ResourceDetailState?) -> ResourceDetailState {
    let state = state ?? ResourceDetailState()
        
    switch action {
    case let action as MAccountFetchedAction:
        var viewmodel = state.info.value
        viewmodel = convertResourceViewModelWithAccount(action.info, viewmodel: viewmodel)
        state.info.accept(viewmodel)
    default:
        break
    }
        
    return state
}

func initViewModel() -> ResourceViewModel {
    let newViewModel = ResourceViewModel(
        general: [GeneralViewModel(name: R.string.localizable.cpu.key.localized(),
                                   eos: "- EOS",
                                   leftSub: R.string.localizable.use.key.localized() +
                                    " - " +
                                    R.string.localizable.ms.key.localized(),
                                   rightSub: R.string.localizable.total.key.localized() +
                                    " - " +
                                    R.string.localizable.ms.key.localized(),
                                   lineHidden: false,
                                   progress: 0.0),
                  GeneralViewModel(name: R.string.localizable.net.key.localized(),
                                   eos: "- EOS",
                                   leftSub: R.string.localizable.use.key.localized() +
                                    " - " +
                                    R.string.localizable.kb.key.localized(),
                                   rightSub: R.string.localizable.total.key.localized() +
                                    " - " +
                                    R.string.localizable.kb.key.localized(),
                                   lineHidden: true,
                                   progress: 0.0),
                  GeneralViewModel(name: R.string.localizable.ram.key.localized(),
                                   eos: "- EOS",
                                   leftSub: R.string.localizable.use.key.localized() +
                                    " - " +
                                    R.string.localizable.kb.key.localized(),
                                   rightSub: R.string.localizable.total.key.localized() +
                                    " - " +
                                    R.string.localizable.kb.key.localized(),
                                   lineHidden: true,
                                   progress: 0.0)])
    return newViewModel
}

func convertResourceViewModelWithAccount(_ account: Account, viewmodel: ResourceViewModel?) -> ResourceViewModel {
    if var newViewModel = viewmodel {
        newViewModel.general[0].eos = account.totalResources?.cpuWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"
        newViewModel.general[1].eos = account.totalResources?.netWeight ?? "- \(NetworkConfiguration.EOSIODefaultSymbol)"

        if let used = account.cpuLimit?.used, let max = account.cpuLimit?.max {

            newViewModel.general[0].leftSub = R.string.localizable.use.key.localized() + " \(used.toMS) " + R.string.localizable.ms.key.localized()
            newViewModel.general[0].rightSub = R.string.localizable.total.key.localized() + " \(max.toMS) " + R.string.localizable.ms.key.localized()
            newViewModel.general[0].progress = used.toMS.float()! / max.toMS.float()!
        }
        if let used = account.netLimit?.used, let max = account.netLimit?.max {
            newViewModel.general[1].leftSub = R.string.localizable.use.key.localized() + " \(used.toKB) " + R.string.localizable.kb.key.localized()
            newViewModel.general[1].rightSub = R.string.localizable.total.key.localized() + " \(max.toKB) " + R.string.localizable.kb.key.localized()
            newViewModel.general[1].progress = used.toKB.float()! / max.toKB.float()!
        }
        if let used = account.ramUsage?.toKB, let max = account.ramQuota?.toKB {
            newViewModel.general[2].leftSub = R.string.localizable.use.key.localized() + " \(used) " + R.string.localizable.kb.key.localized()
            newViewModel.general[2].rightSub = R.string.localizable.total.key.localized() + " \(max) " + R.string.localizable.kb.key.localized()
            newViewModel.general[2].progress = used.float()! / max.float()!
        }
        return newViewModel
    } else {
        var newViewModel = initViewModel()
        newViewModel = convertResourceViewModelWithAccount(account, viewmodel: newViewModel)
        return newViewModel
    }
}
