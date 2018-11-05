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
    @IBOutlet weak var headView: AssetDetailHeadView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!

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
        if headView.currencyLabel.text == "EOS" {
            self.buttonView.isHidden = true
            self.buttonViewHeight.constant = 0
        }
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
