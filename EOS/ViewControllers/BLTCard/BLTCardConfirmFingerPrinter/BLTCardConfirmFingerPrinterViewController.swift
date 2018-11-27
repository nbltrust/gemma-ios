//
//  BLTCardConfirmFingerPrinterViewController.swift
//  EOS
//
//  Created peng zhu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BLTCardConfirmFingerPrinterViewController: BaseViewController {
    @IBOutlet weak var contentView: BLTCardIntroViewView!

	var coordinator: (BLTCardConfirmFingerPrinterCoordinatorProtocol & BLTCardConfirmFingerPrinterStateManagerProtocol)?

    private(set) var context: BLTCardConfirmFingerPrinterContext?

    var indicatorView: UIActivityIndicatorView?

	override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()
        setupEvent()

    }

    func reloadRightItem(_ isStoped: Bool) {
        if isStoped {
            configRightNavButton(R.string.localizable.wookong_retry.key)
            indicatorView?.stopAnimating()
        } else {
            if indicatorView == nil {
                indicatorView = UIActivityIndicatorView(style: .gray)
                indicatorView?.hidesWhenStopped = true
            }
            configRightCustomView(indicatorView!)
            indicatorView?.startAnimating()
        }
    }

    func test() {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func refreshViewController() {

    }

    func setupUI() {
        var uiModel = BLTCardIntroModel()
        guard let context = context else { return }
        if context.confirmSuccessed != nil {
            uiModel.title = R.string.localizable.wookong_confirm_fp_pair.key.localized()
            uiModel.imageName = R.image.card_fingerprint.name
            contentView.adapterModelToBLTCardIntroViewView(uiModel)
        } else {
            uiModel.title = R.string.localizable.wookong_confirm_fp_title.key.localized()
            uiModel.imageName = R.image.card_fingerprint.name
            contentView.adapterModelToBLTCardIntroViewView(uiModel)
        }
    }

    func setupData() {

    }

    func setupEvent() {
        self.startLoading(true)
        guard let context = context else { return }
        if context.confirmSuccessed != nil {
            verifyFP()
        } else {
            reloadRightItem(false)
            self.coordinator?.bltTransferAccounts(context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.reloadRightItem(true)
                    self.coordinator?.finishTransfer()
                } else {
                    self.reloadRightItem(true)
                    self.showError(message: message)
                }
            })
        }
    }

    func verifyFP() {
        self.coordinator?.verifyFP({ (state) in
            }, success: { [weak self] in
                guard let `self` = self else { return }
                self.navigationController?.dismiss(animated: true, completion: {
                    if let context = self.context {
                        context.confirmSuccessed!()
                    }
                })
            }, failed: { [weak self]  (reason) in
                guard let `self` = self else { return }
                if let failedReason = reason {
                    self.showError(message: failedReason)
                }
            }, timeout: { [weak self] in
                guard let `self` = self else { return }
                self.timeoutAlert()
        })
    }

    func timeoutAlert() {
        var context = ScreenShotAlertContext()
        context.title = R.string.localizable.wookong_setfp_timeout.key.localized()
        context.cancelTitle = R.string.localizable.wookong_jump.key.localized()
        context.buttonTitle = R.string.localizable.wookong_retry.key.localized()
        context.imageName = R.image.ic_time.name
        context.needCancel = true
        context.sureShot = { [weak self] () in
            guard let `self` = self else { return }
            self.verifyFP()
        }
        appCoodinator.showGemmaAlert(context)
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? BLTCardConfirmFingerPrinterContext {
                self.context = context

                if context.iconType == LeftIconType.dismiss.rawValue {
                    self.configLeftNavButton(R.image.icTransferClose())
                } else {
                    self.configLeftNavButton(R.image.icBack())
                }
            }
        }).disposed(by: disposeBag)
    }
}
