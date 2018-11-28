//
//  BackupMnemonicWordViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BackupMnemonicWordViewController: BaseViewController {

	var coordinator: (BackupMnemonicWordCoordinatorProtocol & BackupMnemonicWordStateManagerProtocol)?

    @IBOutlet weak var contentView: BackupPrivateKeyView!

    var isWookong: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupUI()
        setupEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popGesture = false
    }

    override func refreshViewController() {

    }

    func setupUI() {
        self.title = R.string.localizable.backup_mnemonic_title.key.localized()
        contentView.redTips = R.string.localizable.backup_mnemonic_red_text.key.localized()
        contentView.buttonTitle = R.string.localizable.backup_mnemonic_knowbtn_title.key.localized()
    }

    override func viewDidDisappear(_ animated: Bool) {
        popGesture = true
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissVC()
    }

    func setupData() {

    }

    func setupEvent() {

    }

    override func configureObserveState() {

    }
}

extension BackupMnemonicWordViewController {
    @objc func know(_ data: [String: Any]) {
        self.coordinator?.pushToMnemonicWordContentVC(isWookong)
    }
}
