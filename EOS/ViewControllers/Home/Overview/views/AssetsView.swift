//
//  AssetsView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class AssetsView: EOSBaseView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: BaseLabel!
    @IBOutlet weak var cnyLabel: BaseLabel!
    @IBOutlet weak var totalLabel: BaseLabel!

    enum Event:String {
        case assetsViewDidClicked
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
        self.next?.sendEventWith(Event.assetsViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
