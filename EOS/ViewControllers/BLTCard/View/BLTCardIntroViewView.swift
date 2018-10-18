//
//  BLTCardIntroViewView.swift
//  EOS
//
//  Created peng zhu on 2018/10/2.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class BLTCardIntroViewView: EOSBaseView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var introView: UIImageView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    enum Event:String {
        case BLTCardIntroViewViewDidClicked
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        introView.contentMode = .scaleAspectFit
    }
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.BLTCardIntroViewViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
