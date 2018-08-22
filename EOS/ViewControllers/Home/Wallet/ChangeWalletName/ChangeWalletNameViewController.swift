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
    
    @IBOutlet weak var changeWalletNameView: ChangeWalletNameView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        self.title = R.string.localizable.change_wallet_name.key.localized()
        configRightNavButton(R.string.localizable.normal_save.key.localized())
        changeWalletNameView.text = model.name
    }
    
    override func rightAction(_ sender: UIButton) {
        //保存
        self.view.endEditing(true)
        model.name = changeWalletNameView.textField.text ?? ""
        if self.coordinator?.updateWalletName(model: model) == true {
            self.coordinator?.popToLastVC()
        }
    }

    override func configureObserveState() {
        
    }
}
