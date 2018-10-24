//
//  Colletion+Extensions.swift
//  EOS
//
//  Created by koofrank on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension Collection {
    subscript(optional index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
