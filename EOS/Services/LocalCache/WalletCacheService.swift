//
//  WalletCacheService.swift
//  EOS
//
//  Created by koofrank on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import GRDB

enum WalletType: Int, DatabaseValueConvertible, Codable {
    case HD
    case bluetooth
    case nonHD
}

struct Wallet: Codable {
    var id: Int64?
    var name: String
    var type: WalletType
    var cipher: String? // 助记词密文
    var deviceName: String? // 蓝牙设备ID
    var date: Date?
    
    public init(id: Int64?, name: String, type: WalletType, cipher: String?, deviceName: String?, date: Date?) {
        self.id = id
        self.name = name
        self.type = type
        self.cipher = cipher
        self.deviceName = deviceName
        self.date = date
    }
}


extension Wallet: MutablePersistableRecord, FetchableRecord {
    static var databaseTableName: String = "Wallet"

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

enum CurrencyType: Int, DatabaseValueConvertible, Codable {
    case EOS
    case ETH
    
    var derivationPath: String {
        switch self {
        case .EOS:
            return "m/44'/194'/0'/0/"
        case .ETH:
            return "m/44'/60'/0'/0/"
        }
    }
}

struct Currency: Codable {
    var id: Int64?
    var type: CurrencyType
    var cipher: String // 私钥密文
    var pubKey: String
    var wid: Int64 // 关联钱包id
    var date: Date?

    public init(id: Int64?, type: CurrencyType, cipher: String, pubKey: String, wid: Int64, date: Date?) {
        self.id = id
        self.type = type
        self.cipher = cipher
        self.pubKey = pubKey
        self.wid = wid
        self.date = date
    }
}

extension Currency: MutablePersistableRecord, FetchableRecord {
    static var databaseTableName: String = "Currency"
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

class WalletCacheService: BaseCacheService {
    static let shared = WalletCacheService()
    
    private init() {
        super.init("db.sqlite")
    }
    
    override func createTable() throws {
        try queue?.write { db in
            try db.create(table: Wallet.databaseTableName) { t in
                t.column("id", .integer).primaryKey()
                t.column("name", .text).notNull()
                t.column("type", .integer).notNull()
                t.column("cipher", .text)
                t.column("deviceName", .text)
                t.column("date", .date).defaults(to: Date())
            }
        }
        
        try queue?.write { db in
            try db.create(table: Currency.databaseTableName) { t in
                t.column("id", .integer).primaryKey()
                t.column("type", .integer).notNull()
                t.column("cipher", .text).notNull()
                t.column("pubKey", .text).notNull()
                t.column("wid", .integer).notNull()
                t.column("date", .date).defaults(to: Date())
            }
        }
    }
    
    override func migration() {
//        //添加字段
//        migrator.registerMigration("AddDateToPlace") { db in
//            do {
//                try db.alter(table: Wallet.databaseTableName, body: {t in
//                    t.add(column: "date", .date).notNull().defaults(to: Date())
//                })
//            } catch let error {
//                dump(error)
//            }
//        }
//        //添加索引
//        migrator.registerMigration("addfavIndex") { db in
//            try? db.create(index: "byFav", on: Wallet.databaseTableName, columns: ["id", "isFavorite"], unique: true)
//        }
//        
//        
//        try? migrator.migrate(queue!)
    }
}

extension WalletCacheService {
    func createWallet(wallet: Wallet, currencys: [Currency]) throws {
        var wallet = wallet

        try queue?.write({ db in
            try wallet.insert(db)
            for var currency in currencys {
                try currency.insert(db)
            }
        })
    }
}

extension WalletCacheService {
    func insertWallet(wallet: Wallet) throws {
        var wallet = wallet
        
        try queue?.write({ db in
            try wallet.insert(db)
        })
    }
    
    func fetchAllWallet() throws -> [Wallet]? {
        return try queue?.inDatabase({ db in
            try Wallet.fetchAll(db)
        })
    }
    
    func updateWallet(_ wallet: Wallet) throws {
        var wallet = wallet
        
        try queue?.inDatabase({ db in
            try wallet.save(db)
        })
    }
    
    func insertCurrency(_ currency: Currency) throws {
        var currency = currency
        
        try queue?.write({ db in
            try currency.insert(db)
        })
    }
    
    func fetchAllCurrencysBy(_ wallet: Wallet) throws -> [Currency]? {
        return try queue?.inDatabase({ db in
            try Currency.fetchAll(db,
                                 "SELECT * FROM Currency WHERE wid = ? ORDER BY date DESC",
                                 arguments: [wallet.id!])
        })
    }
    
    func updateCurrency(_ currency: Currency) throws {
        var currency = currency
        
        try queue?.inDatabase({ db in
            try currency.save(db)
        })
    }
}

