//
//  WalletDetailView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/12.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class WalletDetailView: EOSBaseView {
    
    @IBOutlet weak var nameLineView: LineView!
    @IBOutlet weak var pubkeyLineView: LineView!
    @IBOutlet weak var batteryLineView: LineView!
    @IBOutlet weak var disConnectBtn: Button!
    @IBOutlet weak var formatBtn: Button!
    
    enum Event:String {
        case WalletDetailViewDidClicked
        case nameDidClicked
    }
    
    override var data : Any? {
        didSet {
            
        }
    }
    
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        disConnectBtn.title = R.string.localizable.unpair.key.localized()
        formatBtn.title = R.string.localizable.format.key.localized()
    }
    
    func setupSubViewEvent() {
        nameLineView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.nameLineView.next?.sendEventWith(Event.nameDidClicked.rawValue, userinfo: ["model": self.data ?? []])
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.WalletDetailViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
