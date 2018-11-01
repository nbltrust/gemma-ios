//
//  LeadInKeyViewController.swift
//  EOS
//
//  Created DKM on 2018/7/31.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import XLPagerTabStrip

class LeadInKeyViewController: BaseViewController,IndicatorInfoProvider {

    @IBOutlet weak var leadInKeyView: LeadInKeyView!
    var coordinator: (LeadInKeyCoordinatorProtocol & LeadInKeyStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if leadInKeyView.textView.text == "" {
            leadInKeyView.creatButton.isEnabel.accept(false)
        } else {
            leadInKeyView.creatButton.isEnabel.accept(true)
        }
    }

    func setupUI() {
        self.leadInKeyView.title = R.string.localizable.lead_in_guide.key.localized()

        let placeholder = R.string.localizable.lead_in_placeholder()
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.placeholderColor]
        self.leadInKeyView.textView.attributedPlaceholder = NSMutableAttributedString.init(string: placeholder, attributes: attributes)
    }

    @IBAction func currency(_ sender: Any) {
    }
    
    @IBAction func wallet(_ sender: Any) {
    }
    
    override func configureObserveState() {

    }
}

extension LeadInKeyViewController {
    @objc func beginLeadInAction(_ sender: [String: Any]) {
        guard let priKey = self.leadInKeyView.textView.text else {
            return
        }

        if let valid = self.coordinator?.validPrivateKey(priKey).0 {
            if valid == true {
                self.coordinator?.importPrivKey(priKey)
                self.coordinator?.openSetWallet()
            }
        }
    }
}

extension LeadInKeyViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(stringLiteral: R.string.localizable.priKey_title.key.localized())
    }
}
