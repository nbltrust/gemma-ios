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
        let idStr = Defaults[.currentWalletID]
        if idStr != "" {
            do {
                wallet = try WalletCacheService.shared.fetchWalletBy(id: Int64(idStr)!)
                if let newWallet = wallet as? Wallet {
                    self.contentView.navBarView.adapterModelToNavBarView(newWallet)
                    self.coordinator?.fetchWalletInfo(newWallet)
                }
            } catch {

            }

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

//            if let newWallet = self.wallet as? Wallet {
//                do {
//                    let curArray = try WalletCacheService.shared.fetchAllCurrencysBy(newWallet)
//                    for currency in curArray! {
//                        if let modelStr = Defaults["currency\(currency.id!)"] as? String {
//                            if let model = NewHomeViewModel.deserialize(from: modelStr) {
//                                dataArray.append(model)
//                            }
//                        }
//                    }
//                    self.contentView.adapterModelToNewHomeView(dataArray)
//                } catch {
//
//                }
//            }

            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            
            if let context = context as? NewHomeContext {
                self.context = context
            }
            
        }).disposed(by: disposeBag)
        
//        self.coordinator?.state.pageState.asObservable().distinctUntilChanged().subscribe(onNext: {[weak self] (state) in
//            guard let `self` = self else { return }
//            
//            self.endLoading()
//            
//            switch state {
//            case .initial:
//                self.coordinator?.switchPageState(PageState.refresh(type: PageRefreshType.initial))
//                
//            case .loading(let reason):
//                if reason == .initialRefresh {
//                    self.startLoading()
//                }
//                
//            case .refresh(let type):
//                self.coordinator?.switchPageState(.loading(reason: type.mapReason()))
//                
//            case .loadMore(let page):
//                self.coordinator?.switchPageState(.loading(reason: PageLoadReason.manualLoadMore))
//                
//            case .noMore:
////                self.stopInfiniteScrolling(self.tableView, haveNoMore: true)
//                break
//                
//            case .noData:
////                self.view.showNoData(<#title#>, icon: <#imageName#>)
//                break
//                
//            case .normal(let reason):
////                self.view.hiddenNoData()
////
////                if reason == PageLoadReason.manualLoadMore {
////                    self.stopInfiniteScrolling(self.tableView, haveNoMore: false)
////                }
////                else if reason == PageLoadReason.manualRefresh {
////                    self.stopPullRefresh(self.tableView)
////                }
//                break
//                
//            case .error(let error, let reason):
////                self.showToastBox(false, message: error.localizedDescription)
//                
////                if reason == PageLoadReason.manualLoadMore {
////                    self.stopInfiniteScrolling(self.tableView, haveNoMore: false)
////                }
////                else if reason == PageLoadReason.manualRefresh {
////                    self.stopPullRefresh(self.tableView)
////                }
//                break
//            }
//        }).disposed(by: disposeBag)
    }
}

//MARK: - TableViewDelegate

//extension NewHomeViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.<#cell#>.name, for: indexPath) as! <#cell#>
//
//        return cell
//    }
//}


//MARK: - View Event

extension NewHomeViewController {
    @objc func setDidClicked(_ data:[String: Any]) {
        self.coordinator?.pushToSetVC()
    }
    @objc func walletDidClicked(_ data:[String: Any]) {
        self.coordinator?.pushWallet()
    }
    @objc func cellDidClicked(_ data: [String: Any]) {
        if let model = data["data"] as? NewHomeViewModel {
            if let _ = CurrencyManager.shared.getAccountNameWith(model.id) {
                self.coordinator?.pushToOverviewVCWithCurrencyID(id: model.id)
                CurrencyManager.shared.saveCurrentCurrencyID(model.id)
            } else {
                self.coordinator?.pushToEntryVCWithCurrencyID(id: model.id)
            }
        }
    }
}

