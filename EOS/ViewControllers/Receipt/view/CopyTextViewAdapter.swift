//
//  CopyTextViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension CopyTextView {
    func adapterModelToCopyTextView(_ model:String) {
        textLabel.text = model
    }
}
