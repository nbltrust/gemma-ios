//
//  InvitationView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class InvitationView: BaseView {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var introLabel: BaseLabel!
    @IBOutlet weak var nextButton: Button!
    
    enum Event:String {
        case InvitationViewDidClicked
        case IntroClick
        case NextClick
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        textfield.placeholder = R.string.localizable.invitation_code_placeholder.key.localized()
    }
    
    func setupSubViewEvent() {
        introLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.introLabel.next?.sendEventWith(Event.IntroClick.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
        nextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.nextButton.next?.sendEventWith(Event.NextClick.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.InvitationViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}