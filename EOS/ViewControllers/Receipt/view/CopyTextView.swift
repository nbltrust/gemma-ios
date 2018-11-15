//
//  CopyTextView.swift
//  EOS
//
//  Created zhusongyu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CopyTextView: EOSBaseView {

    @IBOutlet weak var textLabel: BaseLabel!
    @IBOutlet weak var copyLabel: BaseLabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    enum Event:String {
        case copyTextViewDidClicked
        case copyLabelDidClicked
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        copyLabel.text = R.string.localizable.click_copy.key.localized()
    }
    
    func setupSubViewEvent() {
        copyLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] (_) in
            guard let `self` = self else { return }
            copyText(self.textLabel.text!)
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.copyTextViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
