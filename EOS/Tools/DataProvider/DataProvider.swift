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
    
    fileprivate var dbQueue: DatabaseQueue!
    
    func open() throws {
        let urlPath = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("EOS.sqlite")
        dbQueue = try DatabaseQueue(path: urlPath.path)
    }
    
    /*创建数据库*/
    fileprivate func createDB() {
    
    }
    
    /*创建表
     tableName: 表名
     */
    fileprivate func createTable(_ tableName: String) {
        
    }
    
    func saveData(_ data: AnyObject, primaryKey: String) {
        if extsiData(data) {
            updateData(data, primaryKey: primaryKey)
        }
    }
    
    fileprivate func handleData(_ data: Any) -> (tableName: String,datas: [String: Any]) {
        if data is MTLStructType {
            
        } 
//        switch data.dataType {
//        case MTLDataType.struct:
//
//        default:
//            <#code#>
//        }
        return ("", [:])
    }
    
    func updateData(_ data: AnyObject, primaryKey: String) {
        
    }
    
    func extsiData(_ data: AnyObject) -> Bool {
        return true
    }
    
    func deleteData(_ tableName: String, withKey: String, value: Any) {
        
    }
    
    /*
     并列KeyValue条件查询
     */
    func selectData(_ tableName: String, valueConditon: DataFetchCondition) -> [[String : Any]] {
        return selectData(tableName, valueConditions: [valueConditon])
    }
    
    /*
     并列KeyValue条件查询
     valueConditions: [key: value] 查询条件
     */
    func selectData(_ tableName: String, valueConditions: [DataFetchCondition]) -> [[String : Any]] {
        return []
    }
    
    /*
     自定义查询
     condition: 自定义查询条件
     */
    func selectData(_ tableName: String, condition: String) -> [[String : Any]] {
        return selectData(tableName, conditions: [condition])
    }
    
    /*
     并列自定义条件查询
     conditions: 自定义查询条件
     */
    func selectData(_ tableName: String, conditions: [String]) -> [[String : Any]] {
        return []
    }
}
