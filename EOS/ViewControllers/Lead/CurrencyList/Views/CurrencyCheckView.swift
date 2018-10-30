//
//  CurrencyCheckView.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CurrencyCheckView: EOSBaseView {
    enum Event:String {
        case currencyCheckViewDidClicked
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
        self.next?.sendEventWith(Event.currencyCheckViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
