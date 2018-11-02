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
        mnemonicView.title = R.string.localizable.mnemonic_guide.key.localized()
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
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(stringLiteral: R.string.localizable.mnemonic_title.key.localized())
    }
}
