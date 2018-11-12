//
//  GuideContentViewAdapter.swift
//  EOS
//
//  Created peng zhu on 2018/11/8.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

struct GuideModel {
    var image: UIImage?
    var title: String?
    var subTitle: String?

    public init(image: UIImage?, title: String?, subTitle: String?) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
    }
}

extension GuideContentView {
    func adapterModelToGuideContentView(_ model: GuideModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
    }
}
