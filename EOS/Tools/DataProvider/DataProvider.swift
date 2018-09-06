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
    
    fileprivate var dbQueue: DatabaseQueue = DBManager.shared.dbQueue
    
    fileprivate var migrator = DatabaseMigrator()
    
    /*创建表
     tableName: 表名
     */
    fileprivate func createTable(_ tableName: String, data: Any, version: String? = nil) {
    
    }
    
    fileprivate func existTable(_ tableName: String, version: String? = nil) {
        
    }
    
    func saveData(_ data: Any, primaryKey: String?, newVersion: String? = nil) {
        if extsiData(data) {
            updateData(data, primaryKey: primaryKey!)
        }
    }
    
    func updateData(_ data: Any, primaryKey: String) {
        
    }
    
    fileprivate func handleData(_ data: Any) -> (tableName: String,datas: [String: Any]) {
//        if dataType is
//        type(of: <#T##T#>)
        if data is MTLStructType {
//            let dataModdel = data as! str
        }
//        switch data.dataType {
//        case MTLDataType.struct:
//
//        default:
//            <#code#>
//        }
        return ("", [:])
    }
    
    func extsiData(_ data: Any) -> Bool {
        return true
    }
    
    func deleteData(_ tableName: String, valueConditon: DataFetchCondition) {
        
    }

    func fetchCount(_ tableName: String, valueConditon: DataFetchCondition) -> Int {
        return fetchCount(tableName, valueConditon: [valueConditon])
    }
    
    func fetchCount(_ tableName: String, valueConditon: [[DataFetchCondition]]) -> Int {
        return 0
    }
    
    func fetchCount(_ tableName: String, valueConditon: [DataFetchCondition]) -> Int {
        return 0
    }
    
    //Condition Search
    func selectData(_ tableName: String, valueConditon: DataFetchCondition) -> [[String : Any]] {
        return selectData(tableName, valueConditions: [valueConditon])
    }
    
    func selectData(_ tableName: String, valueConditions: [DataFetchCondition]) -> [[String : Any]] {
        return selectData(tableName, valueConditons: [valueConditions])
    }
    
    func selectData(_ tableName: String, valueConditons: [[DataFetchCondition]]) -> [[String : Any]] {
        return []
    }
    
    //Custom search
    func selectData(_ tableName: String, condition: String) -> [[String : Any]] {
        return selectData(tableName, conditions: [condition])
    }
    
    func selectData(_ tableName: String, conditions: [String]) -> [[String : Any]] {
        return selectData(tableName, conditions: [conditions])
    }
    
    func selectData(_ tableName: String, conditions: [[String]]) -> [[String : Any]] {
        return []
    }
}
