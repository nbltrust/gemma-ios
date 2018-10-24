//
//  BatteryView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/8.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class BatteryView: EOSBaseView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressWidthConstant: NSLayoutConstraint!

    enum Event: String {
        case batteryViewDidClicked
    }

    var progress = 0 {
        didSet {
//            borderView.con
            progressWidthConstant.constant = CGFloat(progress / 100) * borderView.width
        }
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
        self.next?.sendEventWith(Event.batteryViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
