//
//  VerifyMnemonicWordCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import ReSwift
import NBLCommonModule
import SwiftyUserDefaults

protocol VerifyMnemonicWordCoordinatorProtocol {
    func popToVC(_ vc: UIViewController)
}

protocol VerifyMnemonicWordStateManagerProtocol {
    var state: VerifyMnemonicWordState { get }

    func switchPageState(_ state: PageState)

    func validSequence(_ datas: [String], compairDatas: [String]) -> Bool

    func checkSeed(_ seed: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void)

    func checkFeedSuccessed()
    func verifyMnemonicWord(_ data: [String: Any], seeds:[String], checkStr: String)
}

class VerifyMnemonicWordCoordinator: NavCoordinator {
    var store = Store(
        reducer: gVerifyMnemonicWordReducer,
        state: nil,
        middleware: [trackingMiddleware]
    )

    var state: VerifyMnemonicWordState {
        return store.state
    }

    override func register() {
        Broadcaster.register(VerifyMnemonicWordCoordinatorProtocol.self, observer: self)
        Broadcaster.register(VerifyMnemonicWordStateManagerProtocol.self, observer: self)
    }
}

extension VerifyMnemonicWordCoordinator: VerifyMnemonicWordCoordinatorProtocol {
    func popToVC(_ vc: UIViewController) {
        self.rootVC.popToViewController(vc, animated: true)
    }

    func popRootVC() {
        if let _ = self.rootVC.viewControllers[0] as? EntryGuideViewController, (UIApplication.shared.delegate as? AppDelegate) != nil {
            appCoodinator.endEntry()
        } else {
            self.rootVC.popToRootViewController(animated: true)
        }
    }
}

extension VerifyMnemonicWordCoordinator: VerifyMnemonicWordStateManagerProtocol {
    func switchPageState(_ state: PageState) {
        DispatchQueue.main.async {
            self.store.dispatch(PageStateAction(state: state))
        }
    }

    func validSequence(_ datas: [String], compairDatas: [String]) -> Bool {
        if datas.count != compairDatas.count {
            return false
        } else {
            for index in 0..<datas.count {
                if datas[index] != compairDatas[index] {
                    return false
                }
            }
        }
        return true
    }

    func checkSeed(_ seed: String, success: @escaping () -> Void, failed: @escaping (String?) -> Void) {
        BLTWalletIO.shareInstance().checkSeed(seed, success: success, failed: failed)
    }

    func checkFeedSuccessed() {
        self.rootVC.viewControllers.forEach { (vc) in
            if let entryVC = vc as? EntryViewController {
                self.popToVC(entryVC)
                entryVC.coordinator?.state.callback.finishBLTWalletCallback.value?()
            }
        }
    }
    
    func verifyMnemonicWord(_ data: [String: Any], seeds:[String], checkStr: String) {
        if let selectValues = data["data"] as? [String]  {
            if selectValues.count == seeds.count {
                let isValid = validSequence(seeds, compairDatas: selectValues)
                if isValid == true {

                    showSuccessTop(R.string.localizable.wookong_mnemonic_ver_successed.key.localized())
                    if let wallet = WalletManager.shared.currentWallet() {
                        WalletManager.shared.backupSuccess(wallet)
                        if wallet.type == .HD {
                            self.popRootVC()
                        } else if wallet.type == .bluetooth {
                            checkSeed(checkStr, success: { [weak self] in
                                guard let `self` = self else { return }
                                self.checkFeedSuccessed()
                                }, failed: { (reason) in
                                    if let failedReason = reason {
                                        showFailTop(failedReason)
                                    }
                            })
                        }
                    }
                } else {
                    showFailTop(R.string.localizable.wookong_mnemonic_ver_failed.key.localized())
                }
            }
        }
    }
}
