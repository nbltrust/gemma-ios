//
//  PriKeyViewController.swift
//  EOS
//
//  Created peng zhu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip

class PriKeyViewController: BaseViewController, IndicatorInfoProvider {

    @IBOutlet weak var priKeyView: PriKeyView!

	var coordinator: (PriKeyCoordinatorProtocol & PriKeyStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureObserveState() {

    }
}

extension PriKeyViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(stringLiteral: R.string.localizable.priKey_title.key.localized())
    }

    @objc func copyPriKey(_ data: [String: Any]) {
        let key = WalletManager.shared.priKey
        let pasteboard = UIPasteboard.general
        pasteboard.string = key
        self.showSuccess(message: R.string.localizable.have_copied.key.localized())
    }
}
