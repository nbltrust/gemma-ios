//
//  BLTCardConfirmPinViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTCardConfirmPinViewController: BaseViewController {

	var coordinator: (BLTCardConfirmPinCoordinatorProtocol & BLTCardConfirmPinStateManagerProtocol)?

    private(set) var context: BLTCardConfirmPinContext?

    @IBOutlet weak var confirmView: TransferConfirmPasswordView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func refreshViewController() {

    }

    func setupUI() {
        self.confirmView.title = R.string.localizable.wookong_confirm_pin_title.key.localized()
        self.confirmView.textField.placeholder = R.string.localizable.wookong_confirm_pin_pla.key.localized()
        self.confirmView.btnTitle = R.string.localizable.wookong_confirm_pin_btn.key.localized()

        if self.navigationController?.viewControllers.count == 1 {
            self.configLeftNavButton(R.image.icTransferClose())
        } else {
            self.configLeftNavButton(R.image.icBack())
        }
    }

    override func leftAction(_ sender: UIButton) {
        if self.navigationController?.viewControllers.count == 1 {
            self.coordinator?.dismissVC {}
        } else {
            self.coordinator?.popVC()
        }
    }

    func setupData() {

    }

    func setupEvent() {
        if self.context?.confirmType == .transferWithPin {
            guard let context = context else { return }
            self.coordinator?.bltTransferAccounts(context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.coordinator?.finishTransfer()
                } else {
                    self.showError(message: message)
                }
            })
        }
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            if let context = context as? BLTCardConfirmPinContext {
                self.context = context
            }
        }).disposed(by: disposeBag)
    }
}

extension BLTCardConfirmPinViewController {
    @objc func sureTransfer(_ data: [String: Any]) {
        guard let context = context else { return }
        if self.context?.confirmType == .verifyPin {
            self.coordinator?.confirmPin(self.confirmView.textField.text ?? "", complication: {
                self.coordinator?.dismissVC({
                    if (context.confirmSuccessed != nil) {
                        context.confirmSuccessed!()
                    }
                })
            })
        } else if self.context?.confirmType == .transferWithPin {
            BLTWalletIO.shareInstance()?.submmitWaitingVerfyPin(self.confirmView.textField.text ?? "")
            self.coordinator?.pushToPowerAlertVC()
        }
    }
}
