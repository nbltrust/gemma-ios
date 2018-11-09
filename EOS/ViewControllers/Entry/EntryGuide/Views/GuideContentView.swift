//
//  GuideContentView.swift
//  EOS
//
//  Created peng zhu on 2018/11/8.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class GuideContentView: EOSBaseView {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subTitleLabel: UILabel!


    enum Event: String {
        case guideContentViewDidClicked
    }

    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }

    func setupUI() {

    }
    
    func setupSubViewEvent() {
    
    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.guideContentViewDidClicked.rawValue, userinfo: ["data": self.data ?? ""])
    }
}
