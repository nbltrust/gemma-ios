//
//  ReceiptView.swift
//  EOS
//
//  Created zhusongyu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class ReceiptView: EOSBaseView {

    @IBOutlet weak var qrcodeImgView: UIImageView!
    @IBOutlet weak var copyTextView: CopyTextView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var nameLabel: BaseLabel!
    
    enum Event:String {
        case receiptViewDidClicked
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
        self.next?.sendEventWith(Event.receiptViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
