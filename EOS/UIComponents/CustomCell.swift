//
//  CustomCell.swift
//  EOS
//
//  Created by peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class CustomCell: BaseTableViewCell {

    @IBOutlet weak var cellView: CustomCellView!

    var title: String = "" {
        didSet {
            cellView.title = title
        }
    }

    var subTitle: String = "" {
        didSet {
            cellView.subTitle = subTitle
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
