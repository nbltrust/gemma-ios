//
//  WalletStateView.swift
//  EOS
//
//  Created peng zhu on 2018/11/15.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class WalletStateView: EOSBaseView {
    enum Event:String {
        case walletStateViewDidClicked
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
        self.next?.sendEventWith(Event.walletStateViewDidClicked.rawValue, userinfo: [:])
    }
}
