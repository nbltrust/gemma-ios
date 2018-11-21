//
//  AccountSwitchView.swift
//  EOS
//
//  Created peng zhu on 2018/11/6.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class AccountSwitchView: BaseView {
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dropView: UIImageView!
    @IBOutlet weak var copyImgView: UIImageView!

    override func setup() {
        super.setup()
        setupUI()
        setupEvent()
    }

    func setupUI() {
        self.needClick = false
    }

    func setupEvent() {
        copyImgView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            copyText(self.nameLabel.text!)
        }).disposed(by: disposeBag)
    }
}
