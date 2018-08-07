//
//  AccountListViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/23.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class AccountListViewController: BaseViewController {

	var coordinator: (AccountListCoordinatorProtocol & AccountListStateManagerProtocol)?

    @IBOutlet weak var accountListView: AccountListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    func setupUI() {
        configLeftNavButton(R.image.icTransferClose())
    }
    
    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissListVC()
    }
    
    func setupData() {
        
        var array: [AccountListViewModel] = []
        for accountName in WalletManager.shared.account_names {
            var model = AccountListViewModel()
            model.account = accountName
            array.append(model)
        }
        accountListView.data = array
        accountListView.tableView.reloadData()
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension AccountListViewController {
    @objc func didselectrow(_ data:[String:Any]) {
        let accountName = data["accountname"]
        
    }
}
