//
//  BackupPrivateKeyViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BackupPrivateKeyViewController: BaseViewController {

    @IBOutlet weak var contentView: BackupPrivateKeyView!

    var coordinator: (BackupPrivateKeyCoordinatorProtocol & BackupPrivateKeyStateManagerProtocol)?

    var publicKey: String = WalletManager.shared.currentPubKey

	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.localizable.copy_priKey_title.key.localized()
        setupData()
    }

    func setupData() {
        contentView.redTips = R.string.localizable.backup_prikey_red_text.key.localized()
        contentView.buttonTitle = R.string.localizable.backup_understand.key.localized()
    }

    override func configureObserveState() {

    }
}

extension BackupPrivateKeyViewController {
    @objc func know(_ data: [String: Any]) {
        self.coordinator?.showPresenterVC(publicKey)
    }
}
