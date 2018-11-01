//
//  DelegateView.swift
//  EOS
//
//  Created zhusongyu on 2018/11/1.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class DelegateView: EOSBaseView {

    @IBOutlet weak var pageView: PageView!
    @IBOutlet weak var nextButton: Button!
    
    enum Event:String {
        case delegateViewDidClicked
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
        self.next?.sendEventWith(Event.delegateViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
