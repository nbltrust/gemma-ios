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

class ChangeWalletNameViewController: BaseViewController {

	var coordinator: (ChangeWalletNameCoordinatorProtocol & ChangeWalletNameStateManagerProtocol)?
    var model = WalletManagerModel()
    var index = -1
    
    @IBOutlet weak var changeWalletNameView: ChangeWalletNameView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        if index == -1 {
            self.title = R.string.localizable.change_wallet_name.key.localized()
            changeWalletNameView.text = model.name
        } else {
            if model.type == .gemma {
                self.title = R.string.localizable.change_wallet_name.key.localized()
                changeWalletNameView.text = model.name
            } else if model.type == .bluetooth {
                self.title = R.string.localizable.change_finger_name.key.localized()
                changeWalletNameView.text = model.fingerNameArray[index]
            }
        }

        configRightNavButton(R.string.localizable.normal_save.key.localized())
    }
    
    override func rightAction(_ sender: UIButton) {
        //保存
        self.view.endEditing(true)

        if index == -1 {
            model.name = changeWalletNameView.textField.text ?? ""
            if self.coordinator?.updateWalletName(model: model) == true {
                self.coordinator?.popToLastVC()
            }
        } else {
            if model.type == .gemma {
                model.name = changeWalletNameView.textField.text ?? ""
                if self.coordinator?.updateWalletName(model: model) == true {
                    self.coordinator?.popToLastVC()
                }
            } else if model.type == .bluetooth {
                model.fingerNameArray[index] = changeWalletNameView.textField.text ?? ""
                if self.coordinator?.updateFingerName(model: model, index: index) == true {
                    self.coordinator?.popToLastVC()
                }
            }
        }
    }

    override func configureObserveState() {
        
    }
}
