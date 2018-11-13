//
//  OverHeadViewView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class OverHeadView: EOSBaseView {

    @IBOutlet weak var cardView: CardView!
    
    enum Event:String {
        case overHeadViewDidClicked
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
        self.next?.sendEventWith(Event.overHeadViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
