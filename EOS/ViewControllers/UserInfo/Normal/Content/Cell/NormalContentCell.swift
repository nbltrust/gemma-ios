//
//  NormalContentCell.swift
//  EOS
//
//  Created by DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class NormalContentCell: BaseTableViewCell {

    @IBOutlet weak var cellView: NormalCellView!
    
    var selectedIndex : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setup(_ data: Any?, indexPath: IndexPath) {
        if let name = data as? String {
            cellView.name_text = name
            cellView.index = indexPath.row
            cellView.rightIconName = selectedIndex == indexPath.row ? "group" : "select"
        }
    }
    
}
