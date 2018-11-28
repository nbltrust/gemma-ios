//
//  WalletItemCell.swift
//  EOS
//
//  Created by peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class WalletItemCell: BaseTableViewCell {

    var moreCallback: CompletionCallback?

    @IBOutlet weak var itemView: WalletItemView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(moreViewClick))
        itemView.moreView.isUserInteractionEnabled = true
        itemView.moreView.addGestureRecognizer(tap)
        // Initialization code
    }

    @objc func moreViewClick() {
        guard let callback = moreCallback else {return}
        callback()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
