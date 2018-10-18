//
//  NewHomeTableCell.swift
//  EOS
//
//  Created by zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//
import UIKit

@IBDesignable
class NewHomeTableCell: BaseTableViewCell {
    
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func setup(_ data: Any?, indexPath: IndexPath) {
        if let data = data as? [NewHomeViewModel] {
            let model = data[indexPath.row]
            self.cardView.adapterModelToCardView(model)
        }
    }
}
