//
//  LeadInKeyViewController.swift
//  EOS
//
//  Created peng zhu on 2018/11/2.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip

class LeadInKeyViewController: BaseViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var leadInKeyView: LeadInKeyView!

    var coordinator: (LeadInKeyCoordinatorProtocol & LeadInKeyStateManagerProtocol)?
    
    private(set) var context: LeadInKeyContext?
    
	override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if leadInKeyView.textView.text == "" {
            leadInKeyView.creatButton.isEnabel.accept(false)
        } else {
            leadInKeyView.creatButton.isEnabel.accept(true)
        }
    }

    override func refreshViewController() {

    }
    
    func setupUI() {
        self.leadInKeyView.title = R.string.localizable.lead_in_guide.key.localized()

        let placeholder = R.string.localizable.lead_in_placeholder()
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.placeholderColor]
        self.leadInKeyView.textView.attributedPlaceholder = NSMutableAttributedString.init(string: placeholder, attributes: attributes)

        self.leadInKeyView.currencyView.needClick = true
        self.leadInKeyView.walletView.needClick = true

        var walletViewIsHidden = true
        let walletArray = WalletManager.shared.walletList()
        if walletArray.count > 0 {
            for wallet in walletArray {
                if wallet.type == .nonHD {
                    walletViewIsHidden = false
                    break
                }
            }
        }
        self.leadInKeyView.walletView.isHidden = walletViewIsHidden
    }

    func setupData() {

    }

    func setupEvent() {
        self.leadInKeyView.currencyView.viewDidClick = {[weak self]() -> Void in
            guard let `self` = self else { return }
            self.coordinator?.pushToCurrencyVC()
        }

        self.leadInKeyView.walletView.viewDidClick = {[weak self]() -> Void in
            guard let `self` = self else { return }
            self.coordinator?.pushToWalletSelectVC()
        }

        self.coordinator?.state.toWallet.asObservable().subscribe(onNext: {[weak self] (wallet) in
            guard let `self` = self else { return }
            if let wallet = wallet {
                self.leadInKeyView.walletView.subTitle = wallet.name
            } else {
                self.leadInKeyView.walletView.subTitle = R.string.localizable.new_wallet.key.localized()
            }
        }).disposed(by: disposeBag)

        self.coordinator?.state.currencyType.asObservable().subscribe(onNext: {[weak self] (type) in
            guard let `self` = self else { return }
            if let type = type {
                self.leadInKeyView.currencyView.subTitle = type.des
            }
        }).disposed(by: disposeBag)
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? LeadInKeyContext {
                self.context = context
            }
        }).disposed(by: disposeBag)
    }
}

extension LeadInKeyViewController {
    @objc func beginLeadInAction(_ sender: [String: Any]) {
        guard let priKey = self.leadInKeyView.textView.text else {
            return
        }
        var isExist = false
        if let wallet = self.coordinator?.state.toWallet.value {
            let currencyArray = CurrencyManager.shared.getAllCurrencys(wallet)
            for currency in currencyArray {
                if currency.type == self.coordinator?.state.currencyType.value {
                    isExist = true
                    break
                }
            }
        }
        if isExist == true {
            let message = R.string.localizable.leadin_wallet_exist.key.localized() + (self.coordinator?.state.currencyType.value?.des)!
            self.showError(message: message)
            return
        }

        if let valid = self.coordinator?.validPrivateKey(priKey) {
            if valid == true {
                self.coordinator?.openSetWallet(priKey)
            } else {
                self.showError(message: R.string.localizable.prikey_verify_fail.key.localized())
            }
        }
    }
}

extension LeadInKeyViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(stringLiteral: R.string.localizable.priKey_title.key.localized())
    }
}
