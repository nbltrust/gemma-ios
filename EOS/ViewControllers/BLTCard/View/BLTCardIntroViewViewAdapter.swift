//
//  BLTCardIntroViewViewAdapter.swift
//  EOS
//
//  Created peng zhu on 2018/10/2.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

extension BLTCardIntroViewView {
    func adapterModelToBLTCardIntroViewView(_ model:BLTCardIntroModel) {
        titleLabel.text = model.title
        let image = UIImage.init(imageLiteralResourceName: model.imageName)
        introView.image = image
    }
}

struct BLTCardIntroModel {
    var title = ""
    var imageName = ""
}
