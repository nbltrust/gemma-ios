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

public protocol DBProtocol: HandyJSON, MutablePersistableRecord, FetchableRecord, Codable {
    init()
    //Table Setting
    mutating func primaryKey() -> String?

    mutating func whiteList() -> [String]?

    mutating func blackList() -> [String]?

    mutating func extensionColumns() -> [String: ParameterType]?

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
            try dbQueue?.write { db in
                try self.save(db)
            }
        } catch {}
    }

    mutating func delete() {
        let dbQueue = DBManager.shared.dbQueue
        do {
            try dbQueue?.write { db in
                try _ = self.delete(db)
            }
        } catch {}
    }
}
