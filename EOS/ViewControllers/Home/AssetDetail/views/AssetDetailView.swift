//
//  AssetDetailView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class AssetDetailView: EOSBaseView {

    @IBOutlet weak var nodeVodeButton: UIButton!
    @IBOutlet weak var resourceManagerButton: UIButton!

    enum Event:String {
        case assetDetailViewDidClicked
        case nodeVodeBtnDidClicked
        case resourceManagerBtnDidClicked
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
        nodeVodeButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(Event.nodeVodeBtnDidClicked.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
        resourceManagerButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(Event.resourceManagerBtnDidClicked.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.assetDetailViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
