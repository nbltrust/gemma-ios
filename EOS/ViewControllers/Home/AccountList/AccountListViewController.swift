//
//  AccountListViewController.swift
//  EOS
//
//  Created peng zhu on 2018/11/7.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class AccountListViewController: BaseViewController {

	var coordinator: (AccountListCoordinatorProtocol & AccountListStateManagerProtocol)?

    @IBOutlet weak var accountListView: AccountListView!

    private(set) var context: AccountListContext?
    
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
        configLeftNavButton(R.image.ic_mask_close())
    }

    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissListVC()
    }

    func setupData() {
        
    }
    
    func setupEvent() {
        var array: [AccountListViewModel] = []
        for accountName in CurrencyManager.shared.getCurrentAccountNames() {
            var model = AccountListViewModel()
            model.account = accountName
            array.append(model)
        }
        accountListView.data = array
        accountListView.didSelect = { [weak self] selectIndex in
            guard let `self` = self else { return }
            if let index = selectIndex as? Int {
                self.coordinator?.selectAtIndex(index)
                self.coordinator?.dismissListVC()
                if self.context?.didSelect != nil {
                    self.context?.didSelect!()
                }
            }
        }
    }


    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? AccountListContext {
                self.context = context
            }

        }).disposed(by: disposeBag)
    }
}

