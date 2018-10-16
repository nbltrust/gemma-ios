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

class WalletManager {
    static let shared = WalletManager()
    
    let keychain = Keychain(service: SwifterSwift.appBundleID ?? "com.nbltrust.gemma")

    var currentPubKey:String = Defaults[.currentWallet]
    var account_names:[String] = Defaults[.accountNames]
    
    var priKey:String = ""
    
    var timer:Repeater?

    private init() {
        //test
        
    }
    
    func createPairKey() {
        if let keys = EOSIO.createKey(), let pub = keys[optional: 0], let pri = keys[optional: 1] {
            currentPubKey = pub
            priKey = pri
        }
    }
    

    func saveWallket(_ account:String, password:String, hint:String, isImport:Bool = false, txID:String? = nil, invitationCode: String? = nil, type: CreateAPPId? = nil, deviceName: String? = nil) {
        if type == .bluetooth {
            savePriKey(priKey,publicKey: currentPubKey, password:password)
            savePasswordHint(currentPubKey, hint:hint)
            
            addToLocalWallet(isImport, accountName: account, type: type, deviceName: deviceName)
            switchWallet(currentPubKey)
            account_names = [account]
            
            switchAccount(0)
            
            removePriKey()
        } else {
            savePriKey(priKey,publicKey: currentPubKey, password:password)
            savePasswordHint(currentPubKey, hint:hint)
            
            addToLocalWallet(isImport, accountName: account, type: type, deviceName: deviceName)
            switchWallet(currentPubKey)
            account_names = [account]
            
            switchAccount(0)
            removePriKey()

        }
    }
    
    func updateWalletPassword(_ password:String, hint:String) {
        guard let pubKey = EOSIO.getPublicKey(self.priKey) else { return }
        savePriKey(self.priKey, publicKey: pubKey, password:password)
        savePasswordHint(pubKey, hint:hint)
    }
    
    func updateWalletName(_  publicKey:String, walletName:String) {
        var wallets = Defaults[.walletList]
        
        if let walletIndex = wallets.map({ $0.publicKey }).index(of: publicKey) {
            var wallet = wallets[walletIndex]
            wallet.name = walletName
            wallets[walletIndex] = wallet
            Defaults[.walletList] = wallets
        }
    }
    
    func addToLocalWallet(_ isImport:Bool = false, accountName:String?, type: CreateAPPId? = nil, deviceName: String? = nil) {
        var wallets = Defaults[.walletList]
        
        if !wallets.map({ $0.publicKey }).contains(currentPubKey) {
            let currentIndex = currentWalletCount() + 1
            var walletName = "EOS-WALLET-\(currentIndex)"
            if let walletType = type, walletType == .bluetooth {
                walletName = "WOOKONG Bio"
            }
            let wallet = WalletList(name: walletName, accountName: accountName, created: "", publicKey: currentPubKey, isBackUp: isImport ? true : false, creatStatus: WalletCreatStatus.willGetAccountInfo.rawValue, getAccountInfoDate: Date(), isImport: isImport, type: type, deviceName: deviceName)
            wallets.append(wallet)
            Defaults[.walletList] = wallets
        }
    }
    
    func getAccount() -> String {
        removePriKey()//清除私钥
        
        if let wallet = currentWallet() {
            if account_names.count == 0 {
                return "--"
            }
            if let walletAccount = wallet.accountName {
                return walletAccount
            }
        }
        
        return "--"
    }
    
    func FetchAccount(_ callback: @escaping StringCallback) {
        if let wallet = currentWallet() {
            if let pubKey = wallet.publicKey {
                if account_names.count == 0 {
                    fetchAccountNames(pubKey) { (success) in
                        if success {
                            callback(self.account_names[0])
                        }
                        else {
                            callback("--")
                        }
                    }
                    return
                }
                return callback(self.account_names[0])
            }
        }
        
        return callback("--")
    }
    
    func fetchAccountNames(_ publicKey:String, completion: @escaping (Bool)->Void) {
        EOSIONetwork.request(target: .get_key_accounts(pubKey: publicKey), success: { (json) in
            if let names = json["account_names"].arrayObject as? [String] {
                self.account_names = names
                Defaults[.accountNames] = names

                completion(names.count > 0)
            }
        }, error: { (code) in
            completion(false)
        }) { (error) in
            completion(false)
        }
    }
    
    func addPrivatekey(_ pri:String) {
        self.priKey = pri
    }
    
    func removePriKey() {
        self.priKey = ""
    }
    
    func importPrivateKey(_ password:String, hint:String, completion: @escaping (Bool)->Void) {
        guard let pubKey = EOSIO.getPublicKey(self.priKey) else { completion(false); return }
        fetchAccountNames(pubKey) { (success) in
            if success {
                self.currentPubKey = pubKey
                
                self.saveWallket(self.account_names[0], password: password, hint: hint, isImport: true, txID: nil, type: .gemma, deviceName: nil)
            }
            completion(success)
        }
    }
    
    func currentWallet() -> WalletList? {
        let pubKey = Defaults[.currentWallet]
        let wallets = wallketList()
        
        if let index = wallets.map({ $0.publicKey }).index(of: pubKey) {
            return wallets[index]
        }
        
        return nil
    }
    
    func isBluetoothWallet() -> Bool {
        if let wallet = currentWallet() {
            return wallet.type == .bluetooth
        }
        return false
    }
    
    func wallketList() -> [WalletList] {
        return Defaults[.walletList]
    }
    
    func switchWallet(_ publicKey:String) {
        currentPubKey = publicKey
        Defaults[.currentWallet] = publicKey
    }
    
    func switchAccount(_ index:Int) {
        var wallets = Defaults[.walletList]
        if let walletIndex = wallets.map({ $0.publicKey }).index(of: currentPubKey) {
            var wallet = wallets[walletIndex]
            wallet.accountName = account_names[index]
            wallets[walletIndex] = wallet
            Defaults[.walletList] = wallets
        }
    }
    
    func existWallet() -> Bool {
        return currentWalletCount() != 0
    }
    
    func registerSuccess(_ pubKey:String) {
        var wallets = wallketList()
        
        if let index = wallets.map({ $0.publicKey }).index(of: pubKey) {
            var wallet = wallets[index]
            wallet.creatStatus = WalletCreatStatus.creatSuccessed.rawValue
            wallets[index] = wallet
            
            Defaults[.walletList] = wallets
        }
    }
    
    func backupSuccess(_ pubKey:String) {
        var wallets = wallketList()
        
        if let index = wallets.map({ $0.publicKey }).index(of: pubKey) {
            var wallet = wallets[index]
            wallet.isBackUp = true
            wallets[index] = wallet
            
            Defaults[.walletList] = wallets
        }
    }
    
    func currentWalletCount() -> Int {
        let wallets = Defaults[.walletList]
       
        return wallets.count
    }
    
    func removeAllWallets() {
        Defaults.remove(.walletList)
    }
    
    func removeWallet(_ publicKey:String) {
        var wallets = Defaults[.walletList]
        if let index = wallets.map({ $0.publicKey }).index(of: publicKey) {
            wallets.remove(at: index)
            Defaults[.walletList] = wallets
        }
        
        try? keychain.remove("\(publicKey)-passwordHint")
        try? keychain.remove("\(publicKey)-pubKey")
        try? keychain.remove("\(publicKey)-cypher")
        
        if wallets.count == 0 {
            app_coodinator.curDisplayingCoordinator().rootVC.popToRootViewController(animated: true)
        } else {
            app_coodinator.curDisplayingCoordinator().rootVC.popToRootViewController(animated: true)
        }
    }
    
    func switchToLastestWallet() -> Bool {
        let wallets = Defaults[.walletList]
        
        if let wallet = wallets.last {
            if let pubKey = wallet.publicKey {
                switchWallet(pubKey)
                return true
            }
        }
        
        return false
    }
    
    func getCurrentSavedPublicKey() -> String {
        return Defaults[.currentWallet]
    }

    private func savePasswordHint(_ publicKey:String, hint:String) {
        guard hint.count > 0 else { return }
        
        keychain[string: "\(publicKey)-passwordHint"] = hint
    }
    
    func getPasswordHint(_ publicKey:String) -> String? {
        if let hint = keychain[string: "\(publicKey)-passwordHint"] {
            return hint
        }
        
        return nil
    }
    
    private func savePriKey(_ privateKey:String, publicKey:String, password:String) {
        if let cypher = EOSIO.getCypher(privateKey, password: password) {
            keychain[string: "\(publicKey)-cypher"] = cypher
        }
    }
    
    func getCachedPriKey(_ publicKey:String, password:String) -> String? {
        if let cypher = keychain[string: "\(publicKey)-cypher"], let pri = EOSIO.getPirvateKey(cypher, password: password), pri.count > 0, pri != "wrong password" {
            self.priKey = pri
            return pri
        }
        return nil
    }
    
    
    //MARK: Check Wallet creation
    func checkCurrentWallet() {
        if let wallet = self.currentWallet() {
            if let creatStatus = wallet.creatStatus {
                switch(creatStatus) {
                case WalletCreatStatus.willGetAccountInfo.rawValue:
                    willGetAccountInfo(wallet)
                case WalletCreatStatus.failedGetAccountInfo.rawValue:
                    failedGetAccountInfo()
                case WalletCreatStatus.failedWithReName.rawValue:
                    failedWithReName()
                case WalletCreatStatus.willGetLibInfo.rawValue:
                    willGetLibInfo(wallet)
                case WalletCreatStatus.creatSuccessed.rawValue:
                    if let pubKey = wallet.publicKey {
                        registerSuccess(pubKey)
                    }
                default:
                    return
                }
                
            }
        }
    }
    
    func getAccoutInfo(_ accountName: String, completion: @escaping (_ success: Bool, _ created: String) -> Void) {
        EOSIONetwork.request(target: .get_account(account: accountName, otherNode: true), success: {[weak self] (account) in
            guard let `self` = self else { return }
            if let account = Account.deserialize(from: account.dictionaryObject) {
                self.checkPubKey(account, completion: { (success) in
                    if success {
                        if let created = account.created {
                            completion(true,created)
                            return
                        }
                    }
//                    else {
//                        if var wallet = self.currentWallet() {
//                            wallet.creatStatus = WalletCreatStatus.failedWithReName.rawValue
//                            self.updateWallet(wallet)
//                            self.checkCurrentWallet()
//                            return
//                        }
//                    }
                    completion(false,"")
                })
            }
        }, error: { (code) in
            completion(false,"")
        }, failure: { (error) in
            completion(false,"")
        })
    }
    
    func getLibInfo(_ created: String, completion: @escaping (Bool) -> Void) {
        EOSIONetwork.request(target: .get_info, success: { (info) in
            let lib = info["last_irreversible_block_num"].stringValue
            EOSIONetwork.request(target: .get_block(num: lib), success: { (block) in
                let time = block["timestamp"].stringValue.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS", region: Region.ISO)!
                let createdTime = created.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSSSS", region: Region.ISO)!
                if  time >= createdTime {
                    completion(true)
                }
                else {
                    completion(false)
                }
                
            }, error: { (code2) in
                completion(false)
            }, failure: { (error2) in
                completion(false)
            })
        }, error: { (code3) in
            completion(false)
        }, failure: { (error3) in
            completion(false)
        })
    }
    
    func willGetAccountInfo(_ wallet: WalletList) {
        var wallet = wallet
        if wallet.getAccountInfoDate == nil {
            wallet.getAccountInfoDate = Date()
            self.updateWallet(wallet)
        }
        self.timer = Repeater.every(.seconds(10)) {[weak self] timer in
            guard let `self` = self else { return }
            if let account = wallet.accountName {
                self.getAccoutInfo(account) {(success, created) in
                    if success {
                        self.closeTimer()
                        wallet.creatStatus = WalletCreatStatus.willGetLibInfo.rawValue
                        wallet.created = created
                    } else {
                        if let startTime = wallet.getAccountInfoDate {
                            let nowTime = Date()
                            if nowTime.timeIntervalSince(startTime) >= 120 {
                                self.closeTimer()
                                wallet.creatStatus = WalletCreatStatus.failedGetAccountInfo.rawValue
                            }
                        }
                    }
                    self.updateWallet(wallet)
                    self.checkCurrentWallet()
                }
            }
        }
        
        timer?.start()
    }
    
    func willGetLibInfo(_ wallet: WalletList) {
        var wallet = wallet
        if let created = wallet.created {
            getLibInfo(created) {[weak self] (success) in
                guard let `self` = self else { return }
                if success {
                    if let account = wallet.accountName {
                        self.getAccoutInfo(account, completion: { (success, created) in
                            if success {
                                wallet.creatStatus = WalletCreatStatus.creatSuccessed.rawValue
                                self.updateWallet(wallet)
                                self.checkCurrentWallet()
                            } else {
                                wallet.creatStatus = WalletCreatStatus.failedGetAccountInfo.rawValue
                                self.updateWallet(wallet)
                                self.checkCurrentWallet()
                            }
                        })
                    }
                } else {
                    self.checkCurrentWallet()
                }
            }
        }
    }
    
    func failedGetAccountInfo() {
        showWarning(R.string.localizable.error_createAccount_failed.key.localized())
        let networkStr = getNetWorkReachability()
        if networkStr != WifiStatus.notReachable.rawValue {
            self.removeWallet(self.currentPubKey)
        } 
    }
    
    func failedWithReName() {
        showWarning(R.string.localizable.error_account_registered.key.localized())
    }
    
    func checkPubKey(_ account: Account, completion:@escaping ResultCallback) {
        for permission in account.permissions {
            for authKey in permission.required_auth.keys {
                if authKey.key == self.currentPubKey {
                    completion(true)
                    return
                }
            }
        }
        completion(false)
    }
    
    func updateWallet(_ wallet: WalletList) {
        var wallets = wallketList()
        if let index = wallets.map({ $0.publicKey }).index(of: currentPubKey) {
            wallets[index] = wallet
            Defaults[.walletList] = wallets
        }
    }
    
    func closeTimer() {
        if self.timer != nil {
            self.timer?.pause()
            self.timer = nil
        }
    }
    
    //MARK: Format Check
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func isValidComfirmPassword(_ password: String, comfirmPassword: String) -> Bool {
        return password == comfirmPassword
    }
    
    func isValidWalletName(_ name: String) -> Bool {
        let regex = "^[1-5a-z]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:name)
    }
    
    //MARK: Account DB
    func getAccountModelsWithAccountName(name: String) -> AccountModel? {
        var condition = DataFetchCondition()
        condition.key = "account_name"
        condition.value = name
        condition.check = .equal
        do {
            let data = try DataProvider.shared.selectData("AccountModel", valueConditon: condition)
            if data.count > 0 {
                let dict = data[0]
                var accountModel = AccountModel()
                accountModel.account_name = dict["account_name"] as? String
                accountModel.net_weight = dict["net_weight"] as? String
                accountModel.cpu_weight = dict["cpu_weight"] as? String
                accountModel.ram_bytes = dict["ram_bytes"] as? Int64
                accountModel.from = dict["from"] as? String
                accountModel.to = dict["to"] as? String
                accountModel.delegate_net_weight = dict["delegate_net_weight"] as? String
                accountModel.delegate_cpu_weight = dict["delegate_cpu_weight"] as? String
                accountModel.request_time = dict["request_time"] as? Date
                accountModel.net_amount = dict["net_amount"] as? String
                accountModel.cpu_amount = dict["cpu_amount"] as? String
                accountModel.net_used = dict["net_used"] as? Int64
                accountModel.net_available = dict["net_available"] as? Int64
                accountModel.net_max = dict["net_max"] as? Int64
                accountModel.cpu_used = dict["cpu_used"] as? Int64
                accountModel.cpu_available = dict["cpu_available"] as? Int64
                accountModel.cpu_max = dict["cpu_max"] as? Int64
                accountModel.ram_quota = dict["ram_quota"] as? Int64
                accountModel.ram_usage = dict["ram_usage"]  as? Int64
                accountModel.created = dict["created"] as? String
                return accountModel
            }

        }
        catch {
            
        }
        return nil
    }
    
    func getFingerNameArray(indexArray: [String]) -> [String]{
        var array: [String] = []
        for str in indexArray {
            if Defaults[WalletManager.shared.getCurrentSavedPublicKey() + str] == nil {
                Defaults[WalletManager.shared.getCurrentSavedPublicKey() + str] = R.string.localizable.finger.key.localized() + str
            }
            if let name = Defaults[WalletManager.shared.getCurrentSavedPublicKey() + str] as? String {
                array.append(name)
            }
        }
        return array
    }
    
    func updateFingerName(_  model:WalletManagerModel, index:Int, fingerName:String) {
        Defaults[model.address + model.fingerIndexArray[index]] = fingerName
    }
    
}
