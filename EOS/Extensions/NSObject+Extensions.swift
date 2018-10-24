//
//  NSObject+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import RxSwift

extension NSObject {
    // Swift extensions *can* add stored properties
    // https://medium.com/@ttikitu/swift-extensions-can-add-stored-properties-92db66bce6cd
    func associatedObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> ValueType)
        -> ValueType {
            if let associated = objc_getAssociatedObject(base, key)
                as? ValueType { return associated }
            let associated = initialiser()
            objc_setAssociatedObject(base, key, associated,
                                     .OBJC_ASSOCIATION_RETAIN)
            return associated
    }

    func associateObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
}

private var bagKey: UInt8 = 0
private var storeKey: UInt8 = 1
private var throttleKey: UInt8 = 2
private var canrepeatKey: UInt8 = 3

extension NSObject {
    var store: [String: Any] {
        get {
            if let storeData = objc_getAssociatedObject(self, &storeKey) as? [String: Any] {
                return storeData
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &storeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var canRepeatContainer: [String: Bool] {
        get {
            if let storeData = objc_getAssociatedObject(self, &throttleKey) as? [String: Bool] {
                return storeData
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &throttleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var canRepeat: Bool {
        get {
            if let storeData = objc_getAssociatedObject(self, &canrepeatKey) as? Bool {
                return storeData
            }
            return true
        }
        set {
            canRepeatContainer["\(self)"] = newValue
            objc_setAssociatedObject(self, &canrepeatKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension NSObject {
    var disposeBag: DisposeBag {
        get {
            return associatedObject(base: self, key: &bagKey, initialiser: { return DisposeBag()})
        }
        set {
            associateObject(base: self, key: &bagKey, value: newValue)
        }
    }
}
