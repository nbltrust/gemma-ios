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

class WallketManager {
    static let shared = WallketManager()
    
    let keychain = Keychain(service: SwifterSwift.appBundleID ?? "com.nbltrust.gemma")

    private init() {
        
    }
    
    func saveWallket(_ account:String, password:String, hint:String) {
        if let keys = EOSIO.createKey(), let pub = keys[optional: 0], let pri = keys[optional: 1] {
            removeWallket(account)

            savePubKey(account, pubKey: pub)
            savePriKey(account, priKey:pri, password: password)
            savePasswordHint(account, hint: hint)
        }
        
    }
    
    func removeWallket(_ account:String) {
        try? keychain.remove("\(account)-passwordHint")
        try? keychain.remove("\(account)-pubKey")
        try? keychain.remove("\(account)-cypher")
    }
    
    private func savePasswordHint(_ account:String, hint:String) {
        guard hint.count > 0 else { return }
        
        keychain[string: "\(account)-passwordHint"] = hint
    }
    
    func getPasswordHint(_ account:String) -> String? {
        if let hint = keychain[string: "\(account)-passwordHint"] {
            return hint
        }
        
        return nil
    }
    
    private func savePubKey(_ account:String, pubKey:String) {
        keychain[string: "\(account)-pubKey"] = pubKey
    }
    
    func getPubKey(_ account:String) -> String? {
        if let pub = keychain[string: "\(account)-pubKey"] {
            return pub
        }
        
        return nil
    }
    
    private func savePriKey(_  account:String, priKey:String, password:String) {
        if let cypher = EOSIO.getCypher(priKey, password: password) {
            keychain[string: "\(account)-cypher"] = cypher
        }
    }
    
    func getPriKey(_ account:String, password:String) -> String? {
        if let cypher = keychain[string: "\(account)-cypher"], let pri = EOSIO.getPirvateKey(cypher, password: password) {
            return pri
        }
        
        return nil
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let regex = "^[0-9a-zA-Z]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:password)
    }
    
    func isValidComfirmPassword(_ password: String, comfirmPassword: String) -> Bool {
        return password == comfirmPassword
    }
    
    func isValidWalletName(_ name: String) -> Bool {
        let regex = "^[0-9a-z]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with:name)
    }
    
}
