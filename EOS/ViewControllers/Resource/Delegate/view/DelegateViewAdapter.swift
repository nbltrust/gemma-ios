//
//  DelegateViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension DelegateView {
    func adapterModelToDelegateView(_ model:PageViewModel) {
        self.pageView.data = model
    }
}
