//
//  DBProtocol.swift
//  EOS
//
//  Created by peng zhu on 2018/9/5.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import HandyJSON
import GRDB

struct AccountModel: DBProtocol {
    var account_name:String! = ""
    
    var balance: String! = "- \(NetworkConfiguration.EOSIO_DEFAULT_SYMBOL)"
    
    var net_weight:String! = ""
    var cpu_weight:String! = ""
    var ram_bytes:Int64! = 0
    
    var from:String! = ""
    var to:String! = ""
    var delegate_net_weight:String! = ""
    var delegate_cpu_weight:String! = ""
    
    var request_time:Date! = Date.init()
    var net_amount:String! = ""
    var cpu_amount:String! = ""
    
    var net_used:Int64! = 0
    var net_available:Int64! = 0
    var net_max:Int64! = 0
    
    var cpu_used:Int64! = 0
    var cpu_available:Int64! = 0
    var cpu_max:Int64! = 0
    
    var ram_quota:Int64! = 0
    var ram_usage:Int64! = 0
    var created:String! = ""
    
    var parent: String! = ""
    var perm_name: String! = ""
    
    var threshold: Int64! = 0
    
    var key:String! = ""
    var weight:Int64! = 0
}

public protocol DBProtocol : HandyJSON, MutablePersistableRecord, FetchableRecord, Codable {
    init()
    //Table Setting
    mutating func primaryKey() -> String?
    
    mutating func whiteList() -> [String]?
    
    mutating func blackList() -> [String]?
    
    mutating func extensionColumns() -> [String : ParameterType]?
    
    //Table Edit
    mutating func save() throws
    
    mutating func delete() throws
}

public protocol MirrortionProtocol {
    
}

extension DBProtocol {
    mutating func save() {
        let dbQueue = DBManager.shared.dbQueue
        do {
            try dbQueue?.write{ db in
                try self.save(db)
            }
        } catch {}
    }
    
    mutating func delete() {
        let dbQueue = DBManager.shared.dbQueue
        do {
            try dbQueue?.write{ db in
                try _ = self.delete(db)
            }
        } catch {}
    }
}

extension DBProtocol where Self == AccountModel {
    mutating func primaryKey() -> String? {
        return "account_name"
    }
    
    mutating func whiteList() -> [String]? {
        return []
    }
    
    mutating func blackList() -> [String]? {
        return []
    }
    
    mutating func extensionColumns() -> [String : ParameterType]? {
        return nil
    }
}

