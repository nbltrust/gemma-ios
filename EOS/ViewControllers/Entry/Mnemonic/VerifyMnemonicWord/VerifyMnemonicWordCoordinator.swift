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
import seed39_ios_golang
import eos_ios_core_cpp

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
        reducer: VerifyMnemonicWordReducer,
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
            for i in 0..<datas.count {
                if datas[i] != compairDatas[i] {
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
                    Broadcaster.notify(EntryStateManagerProtocol.self) { (coor) in
                        let model = coor.state.property.model
                        if model?.type == .HD {
                            createWallet(pwd: (model?.pwd)!, checkStr: checkStr, deviceName: nil)
                        } else if model?.type == .bluetooth {
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
    
    func createWallet(pwd: String, checkStr: String, deviceName: String?) {
        do {
            let wallets = try WalletCacheService.shared.fetchAllWallet()
            let idNum: Int64 = Int64(wallets!.count) + 1
            let date = Date.init()
            let cipher = Seed39KeyEncrypt(pwd, checkStr)
            let wallet = Wallet(id: idNum, name: "EOS-WALLET-\(idNum)", type: .HD, cipher: cipher, deviceName: nil, date: date)
            
            let seed = Seed39SeedByMnemonic(checkStr)
            let prikey = Seed39DeriveWIF(seed, CurrencyType.EOS.derivationPath, true)
            let curCipher = Seed39KeyEncrypt(pwd, prikey)
            let pubkey = EOSIO.getPublicKey(prikey)
            let currencys = try WalletCacheService.shared.fetchAllCurrencysBy(wallet)
            let cuNum: Int64 = Int64(currencys!.count) + 1
            let currency = Currency(id: cuNum, type: .EOS, cipher: curCipher!, pubKey: pubkey!, wid: idNum, date: date, address: nil)
            
            let seed2 = Seed39SeedByMnemonic(checkStr)
            let prikey2 = Seed39DeriveRaw(seed2, CurrencyType.ETH.derivationPath)
            let curCipher2 = Seed39KeyEncrypt(pwd, prikey2)
            let pubkey2 = Seed39GetEthereumPublicKeyFromPrivateKey(prikey2)
            let address = Seed39GetEthereumAddressFromPrivateKey(prikey2)
            let cuNum2: Int64 = Int64(currencys!.count) + 2
            let currency2 = Currency(id: cuNum2, type: .ETH, cipher: curCipher2!, pubKey: pubkey2!, wid: idNum, date: date, address: address)
            
            try WalletCacheService.shared.createWallet(wallet: wallet, currencys: [currency,currency2])
            self.checkFeedSuccessed()
        } catch {
            showFailTop("数据库存储失败")
        }
    }
}
