//
//  NodeSelCell.swift
//  EOS
//
//  Created by peng zhu on 2018/8/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit

class NodeSelCell: UITableViewCell {

    @IBOutlet weak var nodeView: NodeSelView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        self.multipleSelectionBackgroundView = bgView
        // Initialization code
    }

    func setupNode(_ node: NodeVoteViewModel) {
        nodeView.nameLabel.text = node.name
        nodeView.ownerLabel.text = node.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nodeView.checkButton.isSelected = selected
        nodeView.lineView.backgroundColor = UIColor.separatorColor
        // Configure the view for the selected state
    }

}
