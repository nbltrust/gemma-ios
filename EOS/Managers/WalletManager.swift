//
//  WalletManager.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import KeychainAccess
import SwifterSwift
import SwiftyUserDefaults
import Repeat
import SwiftDate
import eos_ios_core_cpp
import seed39_ios_golang
import SwiftyJSON

class WalletManager {
    static let shared = WalletManager()

    let keychain = Keychain(service: SwifterSwift.appBundleID ?? "com.nbltrust.gemma")

    var currentPubKey: String = ""

    var priKey: String = ""

    var timer: Repeater?

    //MARK:Wallet
    func currentWallet() -> Wallet? {
        let walletId = Int64(Defaults[.currentWalletID])
        let wallets = walletList()

        if let index = wallets.map({ $0.id }).index(of: walletId) {
            return wallets[index]
        }

        return nil
    }

    func updateWallet(_ wallet: Wallet) {
        do {
            try WalletCacheService.shared.updateWallet(wallet)
        } catch {}
    }

    func walletList() -> [Wallet] {
        do {
            return try WalletCacheService.shared.fetchAllWallet() ?? []
        } catch {}
        return []
    }

    func removeWallet(_ wallet: Wallet) -> Bool {
        return true
    }

    func switchToLastestWallet() -> Bool {
        let wallets = walletList()

        if let wallet = wallets.last {
            if let walletId = wallet.id {
                switchWallet(walletId)
                return true
            }
        }

        return false
    }

    func switchWallet(_ walletId: Int64) {
        Defaults[.currentWalletID] = walletId.string
    }

    func isBluetoothWallet() -> Bool {
        if let wallet = currentWallet() {
            return wallet.type == .bluetooth
        }
        return false
    }

    func existWallet() -> Bool {
        return currentWalletCount() != 0
    }

    func currentWalletCount() -> Int {
        let wallets = walletList()
        return wallets.count
    }

    func normalWalletName() -> String {
        let wallets = walletList()
        let counts: Int64 = Int64(wallets.count)
        if counts == 0 {
            return "WOOKONG-WALLET"
        } else {
            return "WOOKONG-WALLET-\(counts + 1)"
        }
    }

    func bltWalletName() -> String {
        return "WOOKONG Bio"
    }

    func updateWalletName(_ walletId: Int64, newName: String) {
        do {
            if var wallet = try WalletCacheService.shared.fetchWalletBy(id: walletId) {
                wallet.name = newName
                updateWallet(wallet)
            }
        } catch {}
    }

    func getCachedPriKey(_ wallet: Wallet, password: String, type: CurrencyType) -> String? {
        let checkStr = Seed39KeyDecrypt(password, wallet.cipher)
        let seed = Seed39SeedByMnemonic(checkStr)
        if type == .EOS {
            guard let prikey = Seed39DeriveWIF(seed, CurrencyType.EOS.derivationPath, true) else {
                return nil
            }
            return prikey
        } else if type == .ETH {
            let prikey = Seed39DeriveRaw(seed, CurrencyType.ETH.derivationPath)
            return prikey
        }
        return nil
    }

    func updateWalletPassword(_ wallet: Wallet, oldPassword: String, newPassword: String, hint: String) -> Bool {
        do {
            //Update Wallet Cipher,Hint
            let checkStr = Seed39KeyDecrypt(oldPassword, wallet.cipher)
            let seed = Seed39SeedByMnemonic(checkStr)
            let walletCipher = Seed39KeyEncrypt(newPassword, checkStr)
            var wallet = wallet
            wallet.hint = hint
            wallet.cipher = walletCipher
            WalletManager.shared.updateWallet(wallet)

            if let currencys = try WalletCacheService.shared.fetchAllCurrencysBy(wallet) {
                for var currency in currencys {
                    if currency.type == .EOS {
                        //Update EOS Cipher,pubKey
                        let prikey = Seed39DeriveWIF(seed, CurrencyType.EOS.derivationPath, true)
                        guard let curCipher = EOSIO.getCypher(prikey, password: newPassword) else {
                            return false
                        }
                        currency.cipher = curCipher
                        currency.pubKey = EOSIO.getPublicKey(prikey)
                    } else if currency.type == .ETH {
                        //Update ETH Cipher,Address
                        let prikey = Seed39DeriveRaw(seed, CurrencyType.ETH.derivationPath)
                        guard let curCipher = Seed39KeyEncrypt(newPassword, prikey) else {
                            return false
                        }
                        guard let address = Seed39GetEthereumAddressFromPrivateKey(prikey) else {
                            return false
                        }
                        currency.cipher = curCipher
                        currency.address = address
                    }
                    try WalletCacheService.shared.updateCurrency(currency)
                }
            }
        } catch { return false }
        return false
    }

    //MARK:Wallet BackUp
    func backupSuccess(_ wallet: Wallet) {
        if let walletId = wallet.id {
             Defaults["isWalletCompleteBackup\(walletId)"] = true
        }
    }

    func isWalletCompleteBackup(_ wallet: Wallet) -> Bool {
        if let walletId = wallet.id {
            if let complete = Defaults["isWalletCompleteBackup\(walletId)"] as? Bool {
                return complete
            }
        }
        return false
    }

    //MARK:Wallet PairKey
    func createPairKey() {
        if let keys = EOSIO.createKey(), let pub = keys[optional: 0], let pri = keys[optional: 1] {
            currentPubKey = pub
            priKey = pri
        }
    }

    func clearPairKey() {
        currentPubKey = ""
        priKey = ""
    }
//
//    // MARK: Check Wallet creation
//    func checkCurrentWallet() {
//        if let wallet = self.currentWallet() {
//            if let creatStatus = wallet.creatStatus {
//                switch(creatStatus) {
//                case WalletCreatStatus.willGetAccountInfo.rawValue:
//                    willGetAccountInfo(wallet)
//                case WalletCreatStatus.failedGetAccountInfo.rawValue:
//                    failedGetAccountInfo()
//                case WalletCreatStatus.failedWithReName.rawValue:
//                    failedWithReName()
//                case WalletCreatStatus.willGetLibInfo.rawValue:
//                    willGetLibInfo(wallet)
//                case WalletCreatStatus.creatSuccessed.rawValue:
//                    if let pubKey = wallet.publicKey {
//                        registerSuccess(pubKey)
//                    }
//                default:
//                    return
//                }
//
//            }
//        }
//    }
//
//    func getAccoutInfo(_ accountName: String, completion: @escaping (_ success: Bool, _ created: String) -> Void) {
//        EOSIONetwork.request(target: .getAccount(account: accountName, otherNode: true), success: {[weak self] (account) in
//            guard let `self` = self else { return }
//            if let account = Account.deserialize(from: account.dictionaryObject) {
//                self.checkPubKey(account, completion: { (success) in
//                    if success {
//                        if let created = account.created {
//                            completion(true, created)
//                            return
//                        }
//                    }
////                    else {
////                        if var wallet = self.currentWallet() {
////                            wallet.creatStatus = WalletCreatStatus.failedWithReName.rawValue
////                            self.updateWallet(wallet)
////                            self.checkCurrentWallet()
////                            return
////                        }
////                    }
//                    completion(false, "")
//                })
//            }
//        }, error: { (_) in
//            completion(false, "")
//        }, failure: { (_) in
//            completion(false, "")
//        })
//    }
//
//    func getLibInfo(_ created: String, completion: @escaping (Bool) -> Void) {
//        EOSIONetwork.request(target: .getInfo, success: { (info) in
//            let lib = info["last_irreversible_block_num"].stringValue
//            EOSIONetwork.request(target: .getBlock(num: lib), success: { (block) in
//                let time = block["timestamp"].stringValue.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS", region: Region.ISO)!
//                let createdTime = created.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS", region: Region.ISO)!
//                if  time >= createdTime {
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//
//            }, error: { (_) in
//                completion(false)
//            }, failure: { (_) in
//                completion(false)
//            })
//        }, error: { (_) in
//            completion(false)
//        }, failure: { (_) in
//            completion(false)
//        })
//    }
//
//    func willGetAccountInfo(_ wallet: WalletList) {
//        var wallet = wallet
//        if wallet.getAccountInfoDate == nil {
//            wallet.getAccountInfoDate = Date()
//            self.updateWallet(wallet)
//        }
//        self.timer = Repeater.every(.seconds(10)) {[weak self] _ in
//            guard let `self` = self else { return }
//            if let account = wallet.accountName {
//                self.getAccoutInfo(account) {(success, created) in
//                    if success {
//                        self.closeTimer()
//                        wallet.creatStatus = WalletCreatStatus.willGetLibInfo.rawValue
//                        wallet.created = created
//                    } else {
//                        if let startTime = wallet.getAccountInfoDate {
//                            let nowTime = Date()
//                            if nowTime.timeIntervalSince(startTime) >= 120 {
//                                self.closeTimer()
//                                wallet.creatStatus = WalletCreatStatus.failedGetAccountInfo.rawValue
//                            }
//                        }
//                    }
//                    self.updateWallet(wallet)
//                    self.checkCurrentWallet()
//                }
//            }
//        }
//
//        timer?.start()
//    }
//
//    func willGetLibInfo(_ wallet: WalletList) {
//        var wallet = wallet
//        if let created = wallet.created {
//            getLibInfo(created) {[weak self] (success) in
//                guard let `self` = self else { return }
//                if success {
//                    if let account = wallet.accountName {
//                        self.getAccoutInfo(account, completion: { (success, _) in
//                            if success {
//                                wallet.creatStatus = WalletCreatStatus.creatSuccessed.rawValue
//                                self.updateWallet(wallet)
//                                self.checkCurrentWallet()
//                            } else {
//                                wallet.creatStatus = WalletCreatStatus.failedGetAccountInfo.rawValue
//                                self.updateWallet(wallet)
//                                self.checkCurrentWallet()
//                            }
//                        })
//                    }
//                } else {
//                    self.checkCurrentWallet()
//                }
//            }
//        }
//    }
//
//    func failedGetAccountInfo() {
//        showWarning(R.string.localizable.error_createAccount_failed.key.localized())
////        let networkStr = getNetWorkReachability()
////        if networkStr != WifiStatus.notReachable.rawValue {
////            self.removeWallet(self.currentPubKey)
////        }
//    }
//
//    func failedWithReName() {
//        showWarning(R.string.localizable.error_account_registered.key.localized())
//    }
//
//    func checkPubKey(_ account: Account, completion:@escaping ResultCallback) {
//        for permission in account.permissions {
//            for authKey in permission.requiredAuth.keys {
//                if authKey.key == self.currentPubKey {
//                    completion(true)
//                    return
//                }
//            }
//        }
//        completion(false)
//    }
//
//    func closeTimer() {
//        if self.timer != nil {
//            self.timer?.pause()
//            self.timer = nil
//        }
//    }

    // MARK: Format Check
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }

    func isValidComfirmPassword(_ password: String, comfirmPassword: String) -> Bool {
        return password == comfirmPassword
    }

    func isValidWalletName(_ name: String) -> Bool {
        let regex = "^[1-5a-z]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }

}
