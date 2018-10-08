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
    
    enum Event:String {
        case BatteryViewDidClicked
    }
    
    var progress = 0.0 {
        didSet {
            progressWidthConstant.constant = CGFloat(20 * progress)
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
        self.next?.sendEventWith(Event.BatteryViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
