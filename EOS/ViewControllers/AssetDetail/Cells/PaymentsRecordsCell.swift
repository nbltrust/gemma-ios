//
//  PaymentsRecordsCell.swift
//  EOS
//
//  Created by DKM on 2018/7/9.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class PaymentsRecordsCell: BaseTableViewCell {

    @IBOutlet weak var payRecordsCellView: PaymentsRecordsCellView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setup(_ data: Any?) {
        payRecordsCellView.data = data
    }

}
