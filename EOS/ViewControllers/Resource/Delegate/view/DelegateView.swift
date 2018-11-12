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
    @IBOutlet weak var leftNextButton: Button!
    @IBOutlet weak var rightNextButton: Button!
    
    enum Event:String {
        case delegateViewDidClicked
        case leftnext
        case rightnext
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        leftNextButton.isHidden = false
        rightNextButton.isHidden = true
    }
    
    func setupSubViewEvent() {
        leftNextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.endEditing(true)
            self.sendEventWith(Event.leftnext.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        rightNextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.endEditing(true)
            self.sendEventWith(Event.rightnext.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.delegateViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension DelegateView {
    @objc func left(_ data: [String: Any]) {
        leftNextButton.isHidden = false
        rightNextButton.isHidden = true
    }
    @objc func right(_ data: [String: Any]) {
        leftNextButton.isHidden = true
        rightNextButton.isHidden = false
    }
}
