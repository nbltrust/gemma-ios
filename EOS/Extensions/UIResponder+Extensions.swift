//
//  UIResponder+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension UIResponder {
    func sendEventWith(_ name: String, userinfo: [String: Any]) {
        let sel = Selector("\(name):")
        guard responds(to: sel) else {
            self.next?.sendEventWith(name, userinfo: userinfo)
            return
        }

        let setEvent = unsafeBitCast(method(for: sel), to: SetEventIMP.self)
        setEvent(self, sel, userinfo)
    }

    fileprivate typealias SetEventIMP        = @convention(c) (NSObject, Selector, [String: Any]) -> Void
}
