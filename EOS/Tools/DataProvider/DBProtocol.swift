//
//  DBProtocol.swift
//  EOS
//
//  Created by peng zhu on 2018/9/5.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import GRDB
import HandyJSON

struct TestModel: DBProtocol {
    var int: Int = 0
    var string: String = ""
    var id32: Int32 = 0
    var id8: Int8 = 0
    var id64: Int64 = 0
    var float: Float = 0
    var double: Double = 0
    var date: Date = Date()
    var data: Data = Data()
    var bool: Bool = false
}

public protocol DBProtocol : HandyJSON, MutablePersistableRecord, FetchableRecord, Codable {
    init()
    //Table Setting
    mutating func primaryKey() -> String?
    
    mutating func whiteList() -> [String]?
    
    mutating func blackList() -> [String]?
    
    mutating func relyColumnData() -> (String, Any)?
    
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

extension DBProtocol where Self == TestModel {
    mutating func primaryKey() -> String? {
        return "int"
    }
    
    mutating func whiteList() -> [String]? {
        return []
    }
    
    mutating func blackList() -> [String]? {
        return []
    }
    
    mutating func relyColumnData() -> (String, Any)? {
        return nil
    }
}

