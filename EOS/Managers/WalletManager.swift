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

class WalletManager {
    static let shared = WalletManager()
    
    let keychain = Keychain(service: SwifterSwift.appBundleID ?? "com.nbltrust.gemma")

    var currentPubKey:String = Defaults[.currentWallet]
    var account_names:[String] = []
    
    var priKey:String = ""

    private init() {
        //test
        
    }
    
    func createPairKey() {
        if let keys = EOSIO.createKey(), let pub = keys[optional: 0], let pri = keys[optional: 1] {
            currentPubKey = pub
            priKey = pri
        }
    }
    
    func saveWallket(_ account:String, password:String, hint:String, isImport:Bool = false, txID:String? = nil, invitationCode: String? = nil) {
        savePriKey(priKey,publicKey: currentPubKey, password:password)
        savePasswordHint(currentPubKey, hint:hint)
        
        addToLocalWallet(isImport, txID: txID, invitationCode:invitationCode)
        switchWallet(currentPubKey)
        switchAccount(0)
        
        account_names = [account]
        removePriKey()
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
    
    func addToLocalWallet(_ isImport:Bool = false, txID:String?, invitationCode:String?) {
        var wallets = Defaults[.walletList]
        
        if !wallets.map({ $0.publicKey }).contains(currentPubKey) {
            let currentIndex = currentWalletCount() + 1
            let wallet = WalletList(name: "EOS-WALLET-\(currentIndex)", publicKey: currentPubKey, accountIndex: 0, isBackUp: isImport ? true : false, isConfirmLib: isImport ? true : false, txId: txID, invitationCode:invitationCode ,isImport: isImport)
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
            return account_names[wallet.accountIndex]
        }
        
        return "--"
    }
    
    func FetchAccount(_ callback: @escaping StringCallback) {
        if let wallet = currentWallet() {
            if account_names.count == 0 {
                fetchAccountNames(wallet.publicKey) { (success) in
                    if success {
                        callback(self.account_names[wallet.accountIndex])
                    }
                    else {
                        callback("--")
                    }
                }
                return
            }
            return callback(self.account_names[wallet.accountIndex])
        }
        
        return callback("--")
    }
    
    func fetchAccountNames(_ publicKey:String, completion: @escaping (Bool)->Void) {
        EOSIONetwork.request(target: .get_key_accounts(pubKey: publicKey), success: { (json) in
            if let names = json["account_names"].arrayObject as? [String] {
                self.account_names = names
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
                
                self.saveWallket(self.account_names[0], password: password, hint: hint, isImport: true, txID: nil)
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
    
    func wallketList() -> [WalletList] {
        return Defaults[.walletList]
    }
    
    func switchWallet(_ publicKey:String) {
        currentPubKey = publicKey
        Defaults[.currentWallet] = publicKey
        account_names.removeAll()
    }
    
    func switchAccount(_ index:Int) {
        var wallets = Defaults[.walletList]
        if let walletIndex = wallets.map({ $0.publicKey }).index(of: currentPubKey) {
            var wallet = wallets[walletIndex]
            wallet.accountIndex = index
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
            wallet.isConfirmLib = true
            wallet.txId = nil
            wallet.invitationCode = nil
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
    }
    
    func switchToLastestWallet() -> Bool {
        let wallets = Defaults[.walletList]
        
        if let wallket = wallets.last {
            switchWallet(wallket.publicKey)
            return true
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
    
    func validAccountRegisterSuccess(_ pubKey:String, completion: @escaping (Bool)->Void) {
        var wallets = wallketList()
        
        guard let index = wallets.map({ $0.publicKey }).index(of: pubKey) else {
            completion(false)
            return
        }
        
        var wallet = wallets[index]
    
        guard let txId = wallet.txId else { completion(false); return }

        EOSIONetwork.request(target: .get_transaction(id: txId), success: { (json) in
            if let block_num = json["trx"]["trx"]["ref_block_num"].int, let lib = json["last_irreversible_block"].int {
                if block_num <= lib {
                    self.registerSuccess(pubKey)
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
            else {
                NBLNetwork.request(target: .createAccount(account: self.account_names[wallet.accountIndex], pubKey: pubKey, invitationCode: wallet.invitationCode ?? "", hash: txId), success: { (data) in
                    if let newTxid = data["txId"].string {
                        wallet.txId = newTxid
                        wallets[index] = wallet
                        Defaults[.walletList] = wallets
                    }
                    completion(false)

                }, error: { (code) in
                    self.removeWallet(pubKey)
                    self.switchToLastestWallet()
                    completion(false)

                    if let gemmaerror = GemmaError.NBLNetworkErrorCode(rawValue: code) {
                        
                    }
                }) { (error) in
                    completion(false)

                }
            }

        }, error: { (code) in
            completion(false)
        }) { (error) in
            completion(false)
        }
        
    }
    
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
    
    func validChainAccountCreated(_ account:String, completion:@escaping ResultCallback) {
        EOSIONetwork.request(target: .get_account(account: account), success: { (account) in
            let created = account["created"].stringValue.toISODate()!
            
            EOSIONetwork.request(target: .get_info, success: { (info) in
                let lib = info["last_irreversible_block_num"].stringValue
                EOSIONetwork.request(target: .get_block(num: lib), success: { (block) in
                    let time = block["timestamp"].stringValue.toISODate()!
                    if  time >= created {
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
        }, error: { (code) in
            completion(false)
        }, failure: { (error) in
            completion(false)
        })
    }
}
