//
//  ChangeWalletNameViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

enum ChangeNameType: Int {
    case walletName = 0
    case fingerName
}

class ChangeWalletNameViewController: BaseViewController {

	var coordinator: (ChangeWalletNameCoordinatorProtocol & ChangeWalletNameStateManagerProtocol)?
    var model = WalletManagerModel()
    var fingerIndex = 0
    var type: ChangeNameType = .walletName

    @IBOutlet weak var changeWalletNameView: ChangeWalletNameView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {
        if type == .walletName {
            self.title = R.string.localizable.change_wallet_name.key.localized()
            changeWalletNameView.text = model.name
        } else {
            self.title = R.string.localizable.change_finger_name.key.localized()
            changeWalletNameView.text = FingerManager.shared.fingerName(model, index: fingerIndex)
        }

        configRightNavButton(R.string.localizable.normal_save.key.localized())
    }

    override func rightAction(_ sender: UIButton) {
        //保存
        self.view.endEditing(true)

        if type == .walletName {
            model.name = changeWalletNameView.textField.text ?? ""
            if self.coordinator?.updateWalletName(model: model) == true {
                self.coordinator?.popToLastVC()
            }
        } else {
            if self.coordinator?.updateFingerName(model: model, index: fingerIndex, newName: changeWalletNameView.textField.text ?? "") == true {
                self.coordinator?.popToLastVC()
            }
        }
    }

    override func configureObserveState() {

    }
}
