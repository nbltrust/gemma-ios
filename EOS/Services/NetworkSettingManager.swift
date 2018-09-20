//
//  NetworkSettingManager.swift
//  EOS
//
//  Created by peng zhu on 2018/9/12.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

class NetworkSettingManager {
    static let shared = NetworkSettingManager()
    
    func setup() {
        let urlCache = URLCache(memoryCapacity: memoryCapacity(), diskCapacity: diskCapacity(), diskPath: diskPath())
        URLCache.shared = urlCache
    }
    
    fileprivate func memoryCapacity() -> Int {
        return 20 * 1024 * 1024
    }
    
    fileprivate func diskCapacity() -> Int {
        return 20 * 1024 * 1024
    }
    
    fileprivate func diskPath() -> String? {
        let fileManager = FileManager.default
        var fileDir = URL(string: "")
        do {
            fileDir = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("NetworkDataCache", isDirectory: true)
        } catch {}
        var isDirectory: ObjCBool = false
        if let fileDirURL = fileDir {
            if !fileManager.fileExists(atPath: fileDirURL.path, isDirectory: &isDirectory) {
                do {
                    try fileManager.createDirectory(atPath: fileDirURL.path, withIntermediateDirectories: false)
                } catch {}
            }
            return fileDirURL.path
        }
        return nil
    }
}
