//
//  NavBarView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/22.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class NavBarView: EOSBaseView {
    
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    enum Event:String {
        case navBarViewDidClicked
        case walletDidClicked
        case setDidClicked
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
        walletButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.sendEventWith(Event.walletDidClicked.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        settingButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.sendEventWith(Event.setDidClicked.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.navBarViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
