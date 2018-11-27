//
//  LeadInMnemonicViewController.swift
//  EOS
//
//  Created peng zhu on 2018/10/30.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip

class LeadInMnemonicViewController: BaseViewController,IndicatorInfoProvider {

    @IBOutlet weak var mnemonicView: LeadInKeyView!

    var coordinator: (LeadInMnemonicCoordinatorProtocol & LeadInMnemonicStateManagerProtocol)?

    private(set) var context: LeadInMnemonicContext?

    var isWookong = false

	override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mnemonicView.textView.text == "" {
            mnemonicView.creatButton.isEnabel.accept(false)
        } else {
            mnemonicView.creatButton.isEnabel.accept(true)
        }
    }

    override func refreshViewController() {
        self.coordinator?.presentSetFingerPrinterVC()
    }

    func setupUI() {
        self.title = R.string.localizable.lead_in.key.localized()
        mnemonicView.title = R.string.localizable.mnemonic_guide.key.localized()
        if isWookong {
            configRightNavButton(R.image.ic_notify_scan())
            let btnTitle = R.string.localizable.wookong_init_finish_import.key.localized()
            mnemonicView.creatButton.button.setTitle(btnTitle, for: .normal)
        }
    }

    override func rightAction(_ sender: UIButton) {
        self.coordinator?.presentToScanVC()
    }

    func setupData() {

    }

    func setupEvent() {
        self.mnemonicView.title = R.string.localizable.mnemonic_guide.key.localized()

        let placeholder = R.string.localizable.mnemonic_placeholder()
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.placeholderColor]
        self.mnemonicView.textView.attributedPlaceholder = NSMutableAttributedString.init(string: placeholder, attributes: attributes)

        self.mnemonicView.currencyView.isHidden = true
        self.mnemonicView.walletView.isHidden = true
    }
}

extension LeadInMnemonicViewController {
    @objc func beginLeadInAction(_ sender: [String: Any]) {
        guard let mnemonic = self.mnemonicView.textView.text else {
            return
        }

        if let valid = self.coordinator?.validMnemonic(mnemonic) {
            if valid == true {
                if isWookong {
                    self.coordinator?.importForWookong(mnemonic)
                } else {
                    self.coordinator?.openSetWallet(mnemonic)
                }
            }
        }
    }
}

extension LeadInMnemonicViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(stringLiteral: R.string.localizable.mnemonic_title.key.localized())
    }
}
