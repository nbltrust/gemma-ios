//
//  HomeTableCell.swift
//  EOS
//
//  Created by DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class HomeTableCell: BaseTableViewCell {

    
    @IBOutlet var homeCellView: LineView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func setup(_ data: Any?) {
        
    }
    
}
