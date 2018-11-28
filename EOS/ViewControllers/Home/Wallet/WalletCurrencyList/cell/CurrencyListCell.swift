//
//  CurrencyListCell.swift
//  EOS
//
//  Created by zhusongyu on 2018/11/27.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class CurrencyListCell: BaseTableViewCell {

    @IBOutlet weak var cellView: CurrencyListCellView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setup(_ data: Any?, indexPath: IndexPath) {
        if let data = data as? [Currency] {
            cellView.adapterModelToCurrencyListCellView(data[indexPath.row])
        }
    }
}

