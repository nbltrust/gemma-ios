//
//  AccountSwitchView.swift
//  EOS
//
//  Created peng zhu on 2018/11/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class AccountSwitchView: EOSBaseView {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dropView: UIImageView!

    enum Event:String {
        case accountSwitchViewDidClicked
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
        if let model = data as? AccountSwitchModel {
            if model.more {
                self.next?.sendEventWith(Event.accountSwitchViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
            }
        }
    }
}
