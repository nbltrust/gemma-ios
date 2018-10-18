//
//  DeleteFingerView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class DeleteFingerView: EOSBaseView {
    
    @IBOutlet weak var changeNameLineView: LineView!
    @IBOutlet weak var deleteButton: Button!
    
    enum Event:String {
        case DeleteFingerViewDidClicked
        case ChangeNameViewDidClicked
        case DeleteBtnDidClicked
    }
    
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        changeNameLineView.name_text = R.string.localizable.change_name.key.localized()
    }
    
    func setupSubViewEvent() {
        changeNameLineView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            
            self.changeNameLineView.next?.sendEventWith(Event.ChangeNameViewDidClicked.rawValue, userinfo: ["data": self.data ?? []])
        }).disposed(by: disposeBag)
        
        deleteButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.next?.sendEventWith(Event.DeleteBtnDidClicked.rawValue, userinfo: ["data":self.data ?? []])
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.DeleteFingerViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
