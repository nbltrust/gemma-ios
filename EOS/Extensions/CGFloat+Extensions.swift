//
//  CGFloat+Extensions.swift
//  EOS
//
//  Created by peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

extension CGFloat {
    func adapt() -> CGFloat {
        return self * (UIScreen.main.bounds.width / 375)
    }
}
