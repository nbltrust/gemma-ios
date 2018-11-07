//
//  AssetCell.swift
//  EOS
//
//  Created by zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit

class AssetCell: BaseTableViewCell {

    @IBOutlet weak var assetView: AssetsView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setup(_ data: Any?, indexPath: IndexPath) {
        if let data = data as? AssetViewModel {
            assetView.adapterModelToAssetsView(data)
        }
    }

}
