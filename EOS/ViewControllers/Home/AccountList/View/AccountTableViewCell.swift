//
//  AccountTableViewCell.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class AccountTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var cellView: AccountCellView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setup(_ data: Any?, indexPath: IndexPath) {
        if let data = data as? AccountListViewModel {
            cellView.text = data.account
        }
    }
}
