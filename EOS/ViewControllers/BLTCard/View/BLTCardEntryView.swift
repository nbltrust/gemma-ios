//
//  BLTCardEntryView.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class BLTCardEntryView: BaseView {
    
    @IBOutlet weak var actionView: Button!
    
    @IBOutlet weak var clickLabel: UILabel!
    
    enum Event:String {
        case BLTCardEntryViewDidClicked
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
        self.next?.sendEventWith(Event.BLTCardEntryViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
