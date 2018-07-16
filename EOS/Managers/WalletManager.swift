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

class WallketManager {
    static let shared = WallketManager()
    
    let keychain = Keychain(service: SwifterSwift.appBundleID ?? "com.nbltrust.gemma")

    var pubKey:String = Defaults[.currentWallet]
    private var priKey:String = ""

    private init() {
        //test
        
    }
    
    func createPairKey() {
        if let keys = EOSIO.createKey(), let pub = keys[optional: 0], let pri = keys[optional: 1] {
            pubKey = pub
            priKey = pri
        }
    }
    
    func saveWallket(_ account:String, password:String, hint:String) {
        savePriKey(password)
        savePasswordHint(hint)
        
        addToLocalWallet()
        switchWallet(pubKey)
        switchAccount(account)
        
        priKey = ""
    }
    
    func addToLocalWallet() {
        var wallets = Defaults[.wallets]
        if !wallets.contains(pubKey) {
            wallets.append(pubKey)
            Defaults[.wallets] = wallets
        }
    }
    
    private func removeFromLocalWallet() {
        var wallets = Defaults[.wallets]
        if wallets.contains(pubKey) {
            wallets.removeAll(pubKey)
            Defaults[.wallets] = wallets
        }
        
        Defaults.remove(.currentWallet)
    }
    
    func importPrivateKey(_ pri:String, account:String, password:String, hint:String) {
        priKey = pri
        pubKey = ""//
        
        saveWallket(account, password: password, hint: hint)
    }
    
    func switchWallet(_ publicKey:String) {
        pubKey = publicKey
        Defaults[.currentWallet] = publicKey
    }
    
    func switchAccount(_ account:String) {
        Defaults[.currentAccount] = account
    }
    
    func existAccount() -> Bool {
        return getAccount() != ""
    }
    
    func getAccount() -> String {
        return Defaults[.currentAccount]
    }
    
    func logoutWallet() {
        removeWallket()
        Defaults.remove(.currentAccount)
        
        let wallets = Defaults[.wallets]
        
        if let pub = wallets.last {
            switchWallet(pub)
        }
    }
    
    func removeAllWallets() {
        Defaults.remove(.wallets)
    }
    
    private func removeWallket() {
        removeFromLocalWallet()
        
        try? keychain.remove("\(pubKey)-passwordHint")
        try? keychain.remove("\(pubKey)-pubKey")
        try? keychain.remove("\(pubKey)-cypher")
    }
    
    func getCurrentSavedPublicKey() -> String {
        return Defaults[.currentWallet]
    }

    private func savePasswordHint(_ hint:String) {
        guard hint.count > 0 else { return }
        
        keychain[string: "\(pubKey)-passwordHint"] = hint
    }
    
    func getPasswordHint() -> String? {
        if let hint = keychain[string: "\(pubKey)-passwordHint"] {
            return hint
        }
        
        return nil
    }
    
    private func savePriKey(_ password:String) {
        if let cypher = EOSIO.getCypher(priKey, password: password) {
            keychain[string: "\(pubKey)-cypher"] = cypher
        }
    }
    
    func getCachedPriKey(_ password:String) -> String? {
        if let cypher = keychain[string: "\(pubKey)-cypher"], let pri = EOSIO.getPirvateKey(cypher, password: password), pri.count > 0 {
            return pri
        }
        return nil
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

    
}
