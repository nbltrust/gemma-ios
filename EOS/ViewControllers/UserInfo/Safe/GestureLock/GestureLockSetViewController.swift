//
//  GestureLockSetViewController.swift
//  EOS
//
//  Created peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class GestureLockSetViewController: BaseViewController {

    @IBOutlet weak var infoView: GestureLockInfoView!

    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var lockView: GestureLockView!

    var coordinator: (GestureLockSetCoordinatorProtocol & GestureLockSetStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        self.title = R.string.localizable.setting_set_password.key.localized()
        lockView.delegate = self
    }

    override func configureObserveState() {
        self.coordinator?.state.property.validedPassword.asObservable().subscribe(onNext: {[weak self] (isValided) in
            guard let `self` = self else { return }
            if isValided {
                self.coordinator?.popVC()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        self.coordinator?.state.property.password.asObservable().subscribe(onNext: {[weak self] (password) in
            guard let `self` = self else { return }
            self.infoView.showSelectedItems(password)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        self.coordinator?.state.property.promotData.asObservable().subscribe(onNext: {[weak self] (arg0) in
            guard let `self` = self else { return }
            self.messageLabel.text = arg0.message
            self.messageLabel.textColor = arg0.isWarning ? UIColor.scarlet : UIColor.darkSlateBlue
            if arg0.isWarning {
                self.lockView.warn()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

extension GestureLockSetViewController: GestureLockViewDelegate {
    func gestureLockViewDidTouchesEnd(_ lockView: GestureLockView) {
        let password = lockView.password
        if password.trimmed.count > 0 {
            self.coordinator?.setPassword(lockView.password)
        }
    }
}
