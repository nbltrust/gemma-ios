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

    enum Event: String {
        case deleteFingerViewDidClicked
        case changeNameViewDidClicked
        case deleteBtnDidClicked
    }

    override func setup() {
        super.setup()

        setupUI()
        setupSubViewEvent()
    }

    func setupUI() {
        changeNameLineView.nameText = R.string.localizable.change_name.key.localized()
    }

    func setupSubViewEvent() {
        changeNameLineView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }

            self.changeNameLineView.next?.sendEventWith(Event.changeNameViewDidClicked.rawValue, userinfo: ["data": self.data ?? []])
        }).disposed(by: disposeBag)

        deleteButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.next?.sendEventWith(Event.deleteBtnDidClicked.rawValue, userinfo: ["data": self.data ?? []])
        }).disposed(by: disposeBag)
    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.deleteFingerViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
