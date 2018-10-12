//
//  WalletDetailView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class WalletDetailView: EOSBaseView {
    
    @IBOutlet weak var disConnectBtn: Button!
    @IBOutlet weak var formatBtn: Button!
    
    enum Event:String {
        case WalletDetailViewDidClicked
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        disConnectBtn.title = R.string.localizable.unpair.key.localized()
        formatBtn.title = R.string.localizable.format.key.localized()
    }
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.WalletDetailViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
