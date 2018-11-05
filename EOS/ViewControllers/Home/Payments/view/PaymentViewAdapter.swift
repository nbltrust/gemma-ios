//
//  PaymentViewAdapter.swift
//  EOS
//
//  Created zhusongyu on 2018/11/5.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

extension PaymentView {
    func adapterModelToPaymentView(_ model:[PaymentsRecordsViewModel]) {
        self.data = model
    }
}
