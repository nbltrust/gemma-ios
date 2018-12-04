//
//  BLTCardEntryView.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class BLTCardEntryView: EOSBaseView {

    @IBOutlet weak var actionView: Button!

    @IBOutlet weak var clickLabel: UILabel!

    enum Event: String {
        case BLTCardEntryViewDidClicked
    }

    override func setup() {
        super.setup()

        setupUI()
        setupSubViewEvent()
    }

    func setupUI() {
        let clickStr = R.string.localizable.wookong_des_click.key.localized()
        clickLabel.attributedText = clickStr.set(style: StyleNames.clickLine.rawValue)
    }

    func setupSubViewEvent() {

    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.BLTCardEntryViewDidClicked.rawValue, userinfo: [:])
    }
}
