//
//  PayView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class PayView: EOSBaseView {
    @IBOutlet weak var nextButton: Button!
    
    enum Event:String {
        case PayViewDidClicked
        case NextClick
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
        nextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.nextButton.next?.sendEventWith(Event.NextClick.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.PayViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
