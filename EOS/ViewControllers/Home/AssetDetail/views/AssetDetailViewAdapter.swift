//
//  AssetDetailViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension AssetDetailView {
    func adapterModelToAssetDetailView(_ model:[String: [PaymentsRecordsViewModel]]) {
        self.data = model
    }
}
