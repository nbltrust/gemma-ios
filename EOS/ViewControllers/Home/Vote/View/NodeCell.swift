//
//  NodeCell.swift
//  EOS
//
//  Created by peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class NodeCell: UITableViewCell {

    @IBOutlet weak var nodeView: NodeView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.multipleSelectionBackgroundView = bgView
        // Initialization code
    }

    func setupNode(_ node: NodeVoteViewModel) {
        nodeView.nameLabel.text = node.name
        nodeView.ownerLabel.text = node.name
        nodeView.urlLabel.text = node.url
        nodeView.perLabel.text = node.percent.string
        nodeView.rankLabel.text = node.rank.string
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nodeView.checkButton.isSelected = selected
        nodeView.backgroundColor = UIColor.whiteTwo
        // Configure the view for the selected state
    }

}
