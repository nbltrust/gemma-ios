//
//  DBManager.swift
//  EOS
//
//  Created by peng zhu on 2018/9/5.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import SwiftyJSON
import GRDB
import RxGRDB

enum TableHandleAction: Int {
    case none = 0
    case create
    case migrate
}

class DBManager {
    static let shared = DBManager()
    
    var dbQueue: DatabaseQueue!
    
    func setupDB() {
        do {
            try createDB()
            try checkDB()
        } catch {}
    }
    
    fileprivate func createDB() throws {
        let fileManager = FileManager.default
        
        let fileDir = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("GemmaDB", isDirectory: true)
        let filePath = fileDir.appendingPathComponent("Gemma.sqlite")
        var isDirectory: ObjCBool = false
        if !fileManager.fileExists(atPath: fileDir.path, isDirectory: &isDirectory) {
            try fileManager.createDirectory(atPath: fileDir.path, withIntermediateDirectories: false)
        }
        dbQueue = try DatabaseQueue(path: filePath.path)
    }
    
    fileprivate func checkDB() throws {
        let testModel = TestModel()
        try handleTableCreation(testModel)
    }
    
    fileprivate func handleTableCreation(_ data: Any, primaryKey: String? = nil, whiteList: [String]? = nil, blackList: [String]? = nil, exxtensionColumns: [String : ParameterType]? = nil) throws {
        let anyMirror = Mirror(reflecting: data)
        let tableName = anyMirror.className()
        var dataStructure = anyMirror.dataStructure()
        dataStructure = try handleColums(dataStructure, whiteList: whiteList, blackList: blackList, relyColumData: exxtensionColumns)
        let action = try tableAction(tableName, structure: dataStructure)
        switch action {
        case .create:
            try createTable(tableName, primaryKey: primaryKey, structure: dataStructure)
        case .migrate:
            try migrateTable(tableName, primaryKey: primaryKey, structure: dataStructure)
        default:
            break
        }
    }
    
    fileprivate func handleColums(_ structure: [String : ParameterType], whiteList: [String]? = nil, blackList: [String]? = nil, relyColumData: [String : ParameterType]? = nil) throws -> [String : ParameterType] {
        var tempData: [String : ParameterType] = [:]
        if let relyData = relyColumData {
            relyData.forEach { (data) in
                tempData[data.key] = data.value
            }
        }
        
        if let white = whiteList {
            white.forEach { (key) in
                if structure.keys.contains(key) {
                    tempData[key] = structure[key]
                }
            }
            return tempData
        }
        
        structure.forEach { (key, type) in
            tempData[key] = type
        }
        
        if let black = blackList {
            black.forEach { (key) in
                if structure.keys.contains(key) {
                    tempData.removeValue(forKey: key)
                }
            }
        }
        return tempData
    }
    
    fileprivate func createTable(_ tableName: String, primaryKey: String?, structure: [String : ParameterType]) throws {
        try dbQueue.write{ db in
            try self.handleTableCreation(db, tableName: tableName, primaryKey: primaryKey, structure: structure)
        }
    }
    
    fileprivate func handleTableCreation(_ db: Database, tableName: String, primaryKey: String?, structure: [String : ParameterType]) throws {
        try db.create(table: tableName) { t in
            for key in structure.keys {
                if let value = structure[key] {
                    if let priKey = primaryKey, key == priKey {
                        t.column(key, self.columnType(value)).primaryKey()
                    } else {
                        t.column(key, self.columnType(value))
                    }
                }
            }
        }
    }
    
    fileprivate func migrateTable(_ tableName: String, primaryKey: String?, structure: [String : ParameterType]) throws {
        let tempTableName = tableName + "temp"
        var migrator = DatabaseMigrator()
        migrator.registerMigrationWithDeferredForeignKeyCheck("remove data to newTabel from oldtable") { db in
            try self.handleTableCreation(db, tableName: tempTableName, primaryKey: primaryKey, structure: structure)
            try db.execute(self.migrateSQLStatement(tempTableName, db: db, toTable: tableName))
            try db.drop(table: tableName)
            try db.rename(table: tempTableName, to: tableName)
        }
        try migrator.migrate(dbQueue)
    }
    
    fileprivate func migrateSQLStatement(_ fromTable: String, db: Database, toTable: String) throws -> String {
        var fromKeys: [String] = []
        var tableKeys: String = ""
        let fromColums = try db.columns(in: fromTable)
        fromColums.forEach({ (info) in
            fromKeys.append(info.name)
        })
        let toColums = try db.columns(in: toTable)
        toColums.forEach({ (info) in
            if fromKeys.contains(info.name) {
                tableKeys  = tableKeys + info.name + ","
            }
        })
        if tableKeys.lengthOfBytes(using: .utf8) > 0 {
            tableKeys = tableKeys.substring(from: 0, length: tableKeys.lengthOfBytes(using: .utf8) - 1)!
        }
        return String(format: "INSERT INTO %@(%@) SELECT %@ FROM %@", toTable, tableKeys, tableKeys, fromTable)
    }
    
    fileprivate func tableAction(_ tableName: String, structure: [String : ParameterType]) throws -> TableHandleAction {
        var action = TableHandleAction.none
        try dbQueue.write{ db in
            if try db.tableExists(tableName) {
                let columns = try db.columns(in: tableName)
                if structure.keys.count != columns.count {
                    action = TableHandleAction.migrate
                }
                for colum in columns {
                    if !structure.keys.contains(colum.name) {
                        action = TableHandleAction.migrate
                    }
                }
            } else {
                action = TableHandleAction.create
            }
        }
        return action
    }
    
    fileprivate func columnType(_ origationalType: ParameterType) -> Database.ColumnType {
        switch origationalType {
        case .int, .int8, .int16, .int32, .int64:
            return .integer
        case .double, .float:
            return .double
        case .bool:
            return .boolean
        case .date:
            return .datetime
        case .data:
            return .blob
        case .string:
            return .text
        case .unSupport:
            return .text
        }
    }
    
}
