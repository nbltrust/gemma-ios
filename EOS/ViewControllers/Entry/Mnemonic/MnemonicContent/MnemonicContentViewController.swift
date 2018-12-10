//
//  MnemonicContentViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import NBLCommonModule
import seed39_ios_golang
import Seed39

class MnemonicContentViewController: BaseViewController {

	var coordinator: (MnemonicContentCoordinatorProtocol & MnemonicContentStateManagerProtocol)?

    @IBOutlet weak var contentView: MnemonicContentView!

    var isWookong: Bool = false

    var seeds: [String] = []

    var mnemonic = ""
    
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
        self.title = R.string.localizable.backup_mnemonic_title.key.localized()
        self.coordinator?.showAlertMessage()
    }

    func setupData() {
        if isWookong {
            self.coordinator?.getSeeds({ [weak self] (datas,checkStr) in
                guard let `self` = self else { return }
                if let tempDatas = datas as? [String],let check = checkStr {
                    self.seeds = tempDatas
                    self.coordinator?.setSeeds((tempDatas, check))
                    self.contentView.setMnemonicWordArray(self.seeds)
                }
                }, failed: { [weak self] (reason) in
                    guard let `self` = self else { return }
                    if let failedReason = reason {
                        self.showError(message: failedReason)
                    }
            })
        } else {
            let array = mnemonic.components(separatedBy: " ")
            self.coordinator?.setSeeds((array, mnemonic))
            self.contentView.setMnemonicWordArray(array)
        }
    }
    func setupEvent() {
    }
    override func configureObserveState() {

    }
}

extension MnemonicContentViewController {
    @objc func copied(_ data:[String: Any]) {
        self.coordinator?.pushToVerifyMnemonicVC(isWookong)
    }
}

