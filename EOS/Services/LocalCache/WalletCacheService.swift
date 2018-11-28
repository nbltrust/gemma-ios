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
    var hint: String?

    public init(id: Int64?, name: String, type: WalletType, cipher: String?, deviceName: String?, date: Date?, hint: String?) {
        self.id = id
        self.name = name
        self.type = type
        self.cipher = cipher
        self.deviceName = deviceName
        self.date = date
        self.hint = hint
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

    var des: String {
        switch self {
        case .EOS:
            return "EOS"
        case .ETH:
            return "ETH"
        }
    }

    var icon: UIImage {
        switch self {
        case .EOS:
            return R.image.eos()!
        case .ETH:
            return R.image.eth()!
        }
    }
}

struct Currency: Codable {
    var id: Int64?
    var type: CurrencyType
    var cipher: String // 私钥密文
    var pubKey: String?//只有EOS有公钥，公钥和地址只选其一
    var wid: Int64 // 关联钱包id
    var date: Date?
    var address: String?

    public init(id: Int64?, type: CurrencyType, cipher: String, pubKey: String?, wid: Int64, date: Date?, address: String?) {
        self.id = id
        self.type = type
        self.cipher = cipher
        self.pubKey = pubKey
        self.wid = wid
        self.date = date
        self.address = address
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
            try db.create(table: Wallet.databaseTableName) { tab in
                tab.column("id", .integer).primaryKey()
                tab.column("name", .text).notNull()
                tab.column("type", .integer).notNull()
                tab.column("cipher", .text)
                tab.column("deviceName", .text)
                tab.column("date", .date).defaults(to: Date())
                tab.column("hint", .text)
            }
        }

        try queue?.write { db in
            try db.create(table: Currency.databaseTableName) { tab in
                tab.column("id", .integer).primaryKey()
                tab.column("type", .integer).notNull()
                tab.column("cipher", .text).notNull()
                tab.column("pubKey", .text)
                tab.column("wid", .integer).notNull()
                tab.column("date", .date).defaults(to: Date())
                tab.column("address", .text)
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
    func createWallet(wallet: Wallet, currencys: [Currency]) throws -> Int64? {
        var wallet = wallet

        try queue?.write({ database in
            try wallet.insert(database)
            for var currency in currencys {
                currency.wid = wallet.id ?? 0
                try currency.insert(database)
            }
        })

        return wallet.id
    }

    func fetchWalletBy(id: Int64) throws -> Wallet? {
        return try queue?.inDatabase({ database in
            try Wallet.fetchOne(database,
                                  "SELECT * FROM \(Wallet.databaseTableName) WHERE id = ? ORDER BY id DESC",
                                  arguments: [id])
        })
    }

    func fetchCurrencyBy(id: Int64) throws -> Currency? {
        return try queue?.inDatabase({ database in
            try Currency.fetchOne(database,
                                "SELECT * FROM \(Currency.databaseTableName) WHERE id = ? ORDER BY id DESC",
                arguments: [id])
        })
    }
}

extension WalletCacheService {
    func insertWallet(wallet: Wallet) throws -> Int64? {
        var wallet = wallet

        try queue?.write({ database in
            try wallet.insert(database)
        })

        return wallet.id
    }

    func fetchAllWallet() throws -> [Wallet]? {
        return try queue?.inDatabase({ database in
            try Wallet.fetchAll(database)
        })
    }

    func updateWallet(_ wallet: Wallet) throws {
        var wallet = wallet

        try queue?.inDatabase({ database in
            try wallet.save(database)
        })
    }

    func insertCurrency(_ currency: Currency) throws -> Int64? {
        var currency = currency

        try queue?.write({ database in
            try currency.insert(database)
        })
        return currency.id
    }

    func fetchAllCurrencysBy(_ wallet: Wallet) throws -> [Currency]? {
        return try fetchAllCurrencysBy(wallet.id!)
    }

    func fetchAllCurrencysBy(_ walletId: Int64) throws -> [Currency]? {
        return try queue?.inDatabase({ database in
            try Currency.fetchAll(database,
                                  "SELECT * FROM \(Currency.databaseTableName) WHERE wid = ? ORDER BY date DESC",
                arguments: [walletId])
        })
    }

    func updateCurrency(_ currency: Currency) throws {
        var currency = currency

        try queue?.inDatabase({ database in
            try currency.save(database)
        })
    }
}
