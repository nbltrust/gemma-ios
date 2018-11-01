//
//  AssetDetailHeadView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class AssetDetailHeadView: EOSBaseView {

    @IBOutlet weak var transferButton: Button!
    @IBOutlet weak var receiptButton: Button!
    
    enum Event:String {
        case assetDetailHeadViewDidClicked
        case transferBtnDidClicked
        case receiptBtnDidClicked
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
        transferButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(Event.transferBtnDidClicked.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
        receiptButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(Event.receiptBtnDidClicked.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.assetDetailHeadViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
