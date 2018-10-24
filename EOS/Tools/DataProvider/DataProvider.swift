//
//  DataProvider.swift
//  EOS
//
//  Created by peng zhu on 2018/9/3.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import HandyJSON
import GRDB

class DataProvider {
    static let shared = DataProvider()

    fileprivate var dbQueue: DatabaseQueue? = DBManager.shared.dbQueue

    //Update part colum
    func updateData(_ tableName: String, newData: [String: Any], valueConditon: DataFetchCondition? = nil) throws {
        try updateData(tableName, newData: newData, valueConditions: valueConditon == nil ? [] : [valueConditon!])
    }

    func updateData(_ tableName: String, newData: [String: Any], valueConditions: [DataFetchCondition]) throws {
        try updateData(tableName, newData: newData, mulValueConditons: [valueConditions])
    }

    func updateData(_ tableName: String, newData: [String: Any], mulValueConditons: [[DataFetchCondition]]) throws {
        try dbQueue?.write { db in
            let sqlStr = self.sqlStringWith(mulValueConditons)
            let updateStr = self.sqlSetStringWith(newData)
            try db.execute(String(format: "UPDATE %@ %@ %@", tableName, updateStr, sqlStr))
        }
    }

    //Delete
    func deleteData(_ tableName: String, valueConditon: DataFetchCondition? = nil) throws {
        try deleteData(tableName, valueConditions: valueConditon == nil ? [] : [valueConditon!])
    }

    func deleteData(_ tableName: String, valueConditions: [DataFetchCondition]) throws {
        try deleteData(tableName, mulValueConditons: [valueConditions])
    }

    func deleteData(_ tableName: String, mulValueConditons: [[DataFetchCondition]]) throws {
        try dbQueue?.write { db in
            let sqlStr = self.sqlStringWith(mulValueConditons)
            try db.execute(String(format: "DELETE FROM %@ %@", tableName, sqlStr))
        }
    }

    //Fectch Count
    func fetchCount(_ tableName: String, valueConditon: DataFetchCondition? = nil) throws -> Int {
        if let valueCondition = valueConditon {
            return try fetchCount(tableName, valueConditions: [valueCondition])
        }
        return try fetchCount(tableName, valueConditions: [])
    }

    func fetchCount(_ tableName: String, valueConditions: [DataFetchCondition]) throws -> Int {
        return try fetchCount(tableName, mulValueConditons: [valueConditions])
    }

    func fetchCount(_ tableName: String, mulValueConditons: [[DataFetchCondition]]) throws -> Int {
        let count = try dbQueue?.read { db -> Int in
            let sqlStr = self.sqlStringWith(mulValueConditons)
            if let fetchCount = try Int.fetchOne(db, String(format: "SELECT * FROM %@ %@", tableName, sqlStr)) {
                return fetchCount
            }
            return 0
        }
        return count ?? 0
    }

    //Condition Search
    func selectData(_ tableName: String, valueConditon: DataFetchCondition? = nil) throws -> [[String: Any]] {
        if let valueCondition = valueConditon {
            return try selectData(tableName, valueConditions: [valueCondition])
        }
        return try selectData(tableName, valueConditions: [])
    }

    func selectData(_ tableName: String, valueConditions: [DataFetchCondition]) throws -> [[String: Any]] {
        return try selectData(tableName, mulValueConditons: [valueConditions])
    }

    func selectData(_ tableName: String, mulValueConditons: [[DataFetchCondition]]) throws -> [[String: Any]] {
        let datas = try dbQueue?.read { db -> [[String: Any]] in
            let sqlStr = self.sqlStringWith(mulValueConditons)
            let rows = try Row.fetchAll(db, String(format: "SELECT * FROM %@ %@", tableName, sqlStr))
            let rowDatas = disposeRows(rows)
            return rowDatas
        }
        return datas ?? []
    }

    func sqlSetStringWith(_ newData: [String: Any]) -> String {
        var sqlStr = ""

        newData.forEachInParallel { (arg0) in
            sqlStr.append(arg0.key + "= '" + "\(arg0.value)" + "',")
        }

        if !sqlStr.isEmpty {
            sqlStr.removeLast()
            sqlStr = "SET " + sqlStr
        }
        return sqlStr
    }

    func sqlStringWith(_ valueConditons: [[DataFetchCondition]]) -> String {
        var sqlStr = ""
        for index in 0..<valueConditons.count {
            var itemSql = ""
            let itemConditions = valueConditons[index]
            for itemIndex in 0..<itemConditions.count {
                let condition = itemConditions[itemIndex]
                itemSql.append((itemIndex > 0 ? SQLConditionReLation.and.rawValue : "") + conditionSql(condition))
            }
            sqlStr.append((index > 0 ? SQLConditionReLation.or.rawValue : "") + itemSql)
        }
        if !sqlStr.isEmpty {
            sqlStr = "WHERE " + sqlStr
        }
        return sqlStr
    }

    func conditionSql(_ conditionData: DataFetchCondition) -> String {
        return conditionData.key + conditionData.check.desc() + "'" + conditionData.value + "'"
    }

    //Custom search
    func selectData(_ tableName: String, condition: String) throws -> [[String: Any]] {
        return try selectData(tableName, conditions: [condition])
    }

    func selectData(_ tableName: String, conditions: [String]) throws -> [[String: Any]] {
        return try selectData(tableName, conditions: [conditions])
    }

    func selectData(_ tableName: String, conditions: [[String]]) throws -> [[String: Any]] {
        let datas = try dbQueue?.read { db -> [[String: Any]] in
            var sqlStr = ""
            for index in 0..<conditions.count {
                var itemSql = ""
                let itemConditions = conditions[index]
                for itemIndex in 0..<itemConditions.count {
                    let condition = itemConditions[itemIndex]
                    itemSql.append((itemIndex > 0 ? SQLConditionReLation.and.desc() : "") + condition)
                }
                sqlStr.append((index > 0 ? SQLConditionReLation.or.desc() : "") + itemSql)
            }
            if !sqlStr.isEmpty {
                sqlStr = "WHERE " + sqlStr
            }
            let rows = try Row.fetchAll(db, String(format: "SELECT * FROM %@ %@", tableName, sqlStr))
            let rowDatas = disposeRows(rows)
            return rowDatas
        }
        return datas ?? []
    }

    func disposeRows(_ rows: [Row]) -> [[String: Any]] {
        let datas: [[String: Any]] = rows.map { row in
            var data: [String: Any] = [:]
            row.columnNames.forEach({ (key) in
                data[key] = row[key]
            })
            return data
        }
        return datas
    }

}
