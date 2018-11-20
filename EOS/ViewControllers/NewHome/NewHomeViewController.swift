//
//  NewHomeViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/10/17.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import SwiftyUserDefaults

class NewHomeViewController: BaseViewController {

	var coordinator: (NewHomeCoordinatorProtocol & NewHomeStateManagerProtocol)?
    private(set) var context: NewHomeContext?
    
    @IBOutlet weak var contentView: NewHomeView!

    var wallet: Any?
    var dataArray: [NewHomeViewModel] = []

	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupData()
    }

    override func refreshViewController() {

    }
    
    func setupUI() {
        hiddenNavBar()
    }

    func setupData() {
        self.dataArray.removeAll()
        if let wallet = WalletManager.shared.currentWallet() {
            self.contentView.navBarView.adapterModelToNavBarView(wallet)
            self.coordinator?.fetchWalletInfo(wallet)
        }
    }

    func setupEvent() {

    }

    override func configureObserveState() {
        self.coordinator?.state.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if let newModel = model as? NewHomeViewModel, newModel.id != 0 {
                for index in 0..<self.dataArray.count {
                    let data = self.dataArray[index]
                    if data.id != newModel.id {
                        self.dataArray.append(newModel)
                    } else {
                        self.dataArray.remove(at: index)
                        self.dataArray.insert(newModel, at: index)
                    }
                }
                if self.dataArray.count == 0 {
                    self.dataArray.append(newModel)
                }
                self.contentView.adapterModelToNewHomeView(self.dataArray)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            if let context = context as? NewHomeContext {
                self.context = context
            }
        }).disposed(by: disposeBag)
    }
}

//MARK:- View Event
extension NewHomeViewController {
    @objc func setDidClicked(_ data: [String: Any]) {
        self.coordinator?.presentSettingVC()
    }

    @objc func walletDidClicked(_ data: [String: Any]) {
        self.coordinator?.presentWalletVC()
    }

    @objc func cellDidClicked(_ data: [String: Any]) {
        if let model = data["data"] as? NewHomeViewModel {
            if let _ = CurrencyManager.shared.getAccountNameWith(model.id), CurrencyManager.shared.getActived(model.id) == true {
                CurrencyManager.shared.saveCurrentCurrencyID(model.id)
                self.coordinator?.pushToOverviewVCWithCurrencyID(currencyId: model.id)
            } else {
                CurrencyManager.shared.saveCurrentCurrencyID(model.id)
                self.coordinator?.pushToEntryVCWithCurrencyID(currencyId: model.id)
            }
        }
    }
}
